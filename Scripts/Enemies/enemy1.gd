extends CharacterBody2D

@export var pathfinding_component: PathfindingComponent

const acceleration = 1000
const deceleration = 2000

var jumpForce: float = 300

var gravity = 980
@export var maxSpeed = 200

var tempMaxSpeed = maxSpeed
var dashSpeed: float = 100
var dashDuration: float = 0.6
var dashCooldown: float = 2
var isDashing = false
var canDash = true
var dashTimer = Timer.new()
var cooldownTimer = Timer.new()

var jumpTimer = Timer.new()
var jumpInterval: float = 2.5

var state_machine

var runIntoDamage: float = 3

var isDead = false

func _ready():
	dashTimer.set_one_shot(true)
	cooldownTimer.set_one_shot(true)
	add_child(dashTimer)
	add_child(cooldownTimer)
	dashTimer.timeout.connect(_on_dashTimer_timeout)
	cooldownTimer.timeout.connect(_on_cooldownTimer_timeout)
	
	$AnimationTree.active = true
	$AnimatedSprite2D.visible = false


func _on_dashTimer_timeout():
	tempMaxSpeed = maxSpeed
	isDashing = false
	
func _on_cooldownTimer_timeout():
	canDash = true

func _physics_process(delta):
	state_machine = $AnimationTree.get("parameters/playback")
	
	xaccelerate(pathfinding_component.sendMovement(self), delta)
	player_movement(velocity, delta)
	dashAttack()
	
	var dir = pathfinding_component.sendMovement(self)
	
	if isDead:
		velocity = Vector2.ZERO
		$HitboxComponent.monitorable = false
	
	if dir > 0:
		$Sprite.set_flip_h(true)
		state_machine.travel("idle")
		if isDashing:
			state_machine.travel("attack")
		elif abs(velocity.x) > 0:
			state_machine.travel("move")
		pass
	elif dir < 0:
		$Sprite.set_flip_h(false)
		state_machine.travel("idle")
		if isDashing:
			state_machine.travel("attack")
		elif abs(velocity.x) > 0:
			state_machine.travel("move")
		pass
	else: state_machine.travel('idle')
	

func dashAttack():
	if pathfinding_component.isInVision() and canDash and not isDashing and is_on_floor():
		tempMaxSpeed = dashSpeed
		isDashing = true
		# Apply Movement
		
		velocity.x += pathfinding_component.sendMovement(self) * dashSpeed
		
		dashTimer.wait_time = dashDuration
		dashTimer.start()
		
		canDash = false
		cooldownTimer.wait_time = dashCooldown
		cooldownTimer.start()

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
		
func _on_health_component_die_animation():
	isDead = true
	$AnimatedSprite2D.visible = true
	$Sprite.visible = false
	$AnimatedSprite2D.play("death")
