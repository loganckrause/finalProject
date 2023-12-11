extends CharacterBody2D

@export var pathfinding_component: PathfindingComponent

const acceleration = 1000
const deceleration = 2000

var jumpForce: float = 300

var gravity = 980
@export var maxSpeed = 200

var isAttacking = false

var state_machine

var runIntoDamage: float = 3

var isDead = false

func _ready():
	$AnimationTree.active = true
	$AnimatedSprite2D.visible = false

func _physics_process(delta):
	$burstWeapon.position = self.global_position
	
	state_machine = $AnimationTree.get("parameters/playback")
	
	xaccelerate(pathfinding_component.sendMovement(self), delta)
	player_movement(velocity, delta)
	
	var dir = pathfinding_component.sendMovement(self)
	
	if isDead:
		velocity = Vector2.ZERO
		$HitboxComponent.monitorable = false
	
	if dir > 0:
		$Sprite.set_flip_h(false)
		state_machine.travel("idle")
		if isAttacking:
			state_machine.travel("attack")
		elif abs(velocity.x) > 0:
			state_machine.travel("move")
		pass
	elif dir < 0:
		$Sprite.set_flip_h(true)
		state_machine.travel("idle")
		if isAttacking:
			state_machine.travel("attack")
		elif abs(velocity.x) > 0:
			state_machine.travel("move")
		pass
	else: state_machine.travel('idle')
	

func player_movement(_velocity, delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
	
func xaccelerate(direction, delta):
	var xInput = direction * acceleration * delta
	velocity.x += xInput
	if abs(velocity.x) > maxSpeed:
		velocity.x = direction * maxSpeed
	
	if direction == 0:
		var friction = min(deceleration * delta, abs(velocity.x))
		if velocity.x > 0:
			velocity.x = max(0, velocity.x - friction)
		elif velocity.x < 0:
			velocity.x = min(0, velocity.x + friction)


func _on_burst_weapon_weapon_shot():
	isAttacking = true
	await(get_tree().create_timer(1).timeout)
	isAttacking = false


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
