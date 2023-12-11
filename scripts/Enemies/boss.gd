extends CharacterBody2D

@export var pathfinding_component: PathfindingComponent

@onready var player = get_tree().get_first_node_in_group("player")
@export var health_component : HealthComponent

const acceleration = 1000
const deceleration = 2000

var jumpForce: float = 300

var gravity = 980
@export var maxSpeed = 200

var tempMaxSpeed = maxSpeed
var dashSpeed: float = 300
var punchDistance: float = 20

var dashDuration: float = 1.3
var dashCooldown: float = 4

var isDashing = false
var canDash = true

var attackTimer = Timer.new()
var dashTimer = Timer.new()
var dashCooldownTimer = Timer.new()
var jumpTimer = Timer.new()

var attackInterval: float = 5
var jumpInterval: float = 2.5

var state_machine

var burstTimer = Timer.new()
var burstInterval: float = 2.0
var wallBurstTimer = Timer.new()
var wallBurstInterval: float = 2.5

var runIntoDamage: float = 3

var isAttacking = false
var isCasting = false

func make_timers():
	attackTimer.set_one_shot(true)
	dashTimer.set_one_shot(true)
	dashCooldownTimer.set_one_shot(true)

	add_child(dashTimer)
	add_child(dashCooldownTimer)

	dashTimer.timeout.connect(_on_dashTimer_timeout)
	dashCooldownTimer.timeout.connect(_on_dashCooldownTimer_timeout)
	
	dashTimer.wait_time = dashDuration
	dashCooldownTimer.wait_time = dashCooldown

func _ready():
	make_timers()
	$AnimationTree.active = true

# Timer Timeouts

func _on_dashTimer_timeout():
	tempMaxSpeed = maxSpeed
	isDashing = false
	
func _on_dashCooldownTimer_timeout():
	canDash = true

func dashAttack():
	if pathfinding_component.isInVision() and canDash and not isDashing and is_on_floor():
		tempMaxSpeed = dashSpeed
		isDashing = true
		# Apply Movement
		
		velocity.x += pathfinding_component.sendMovement(self) * dashSpeed
		
		dashTimer.wait_time = dashDuration
		dashTimer.start()
		
		canDash = false
		dashCooldownTimer.wait_time = dashCooldown
		dashCooldownTimer.start()

func _process(delta):
	$bossWeapon.position = self.global_position-Vector2(0,-20)
	
func _physics_process(delta):
	state_machine = $AnimationTree.get("parameters/playback")
	
	xaccelerate(pathfinding_component.sendMovement(self), delta)
	player_movement(velocity, delta)
	dashAttack()
	
	var dir = pathfinding_component.sendMovement(self)
	
	if dir > 0:
		$Sprite.set_flip_h(false)
		state_machine.travel("idle")
		if isDashing:
			state_machine.travel("dash")
		elif isCasting:
			velocity.x = 0
			state_machine.travel("cast")
		elif isAttacking:
			velocity.x = 0
			state_machine.travel("attack1")
		elif abs(velocity.x) > 0:
			state_machine.travel("walk")
		pass
	elif dir < 0:
		$Sprite.set_flip_h(true)
		state_machine.travel("idle")
		if isDashing:
			state_machine.travel("dash")
		elif isCasting:
			velocity.x = 0
			state_machine.travel("cast")
		elif isAttacking:
			velocity.x = 0
			state_machine.travel("attack1")
		elif abs(velocity.x) > 0:
			state_machine.travel("walk")
		pass
	else: state_machine.travel('idle')
	
func player_movement(_velocity, delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
	
func xaccelerate(direction, delta):
	var xInput = direction * acceleration * delta
	velocity.x += xInput
	if abs(velocity.x) > tempMaxSpeed:
		velocity.x = direction * tempMaxSpeed
	
	if direction == 0:
		var friction = min(deceleration * delta, abs(velocity.x))
		if velocity.x > 0:
			velocity.x = max(0, velocity.x - friction)
		elif velocity.x < 0:
			velocity.x = min(0, velocity.x + friction)
func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent and area.name == "PlayerHitboxComponent":
		var hitbox : HitboxComponent = area

		var attack = Attack.new()
		attack.attack_damage = runIntoDamage

		hitbox.damage(attack)

func _on_boss_weapon_burst():
	isAttacking = true
	await(get_tree().create_timer(1.6).timeout)
	isAttacking = false

func _on_boss_weapon_wall():
	isCasting = true
	await(get_tree().create_timer(1.6).timeout)
	isCasting = false
