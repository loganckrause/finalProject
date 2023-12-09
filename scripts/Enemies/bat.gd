extends CharacterBody2D

@export var pathfinding_component: PathfindingComponent

@onready var player = get_tree().get_first_node_in_group("player")

const acceleration = 700
const decelerationx = 500
const decelerationy = 300


@export var maxSpeed = 70

var tempMaxSpeed = maxSpeed
var dashSpeed: float = 300
var dashDuration: float = 1
var dashCooldown: float = 3
var isDashing = false
var canDash = true
var dashTimer = Timer.new()
var cooldownTimer = Timer.new()

var state_machine

func _ready():
	dashTimer.set_one_shot(true)
	cooldownTimer.set_one_shot(true)
	add_child(dashTimer)
	add_child(cooldownTimer)
	dashTimer.timeout.connect(_on_dashTimer_timeout)
	cooldownTimer.timeout.connect(_on_cooldownTimer_timeout)
	
	$AnimationTree.active = true


func _on_dashTimer_timeout():
	tempMaxSpeed = maxSpeed
	isDashing = false
	
func _on_cooldownTimer_timeout():
	canDash = true


func _physics_process(delta):
	state_machine = $AnimationTree.get("parameters/playback")
	
	var angleToPlayer = vectorToAngle(pathfinding_component.getDistanceBetweenTargets(self.position, player.position))
	
	var direction = getDirection(angleToPlayer)
	
	accelerate(direction, delta)
	player_movement(velocity)
	dashAttack(direction)
	
	var dir = pathfinding_component.sendMovement(self)
	
	if dir > 0:
		$Sprite.set_flip_h(false)
		state_machine.travel("idle")
		if isDashing:
			state_machine.travel("attack")
		pass
	elif dir < 0:
		$Sprite.set_flip_h(true)
		state_machine.travel("idle")
		if isDashing:
			state_machine.travel("attack")
		pass
	else: pass
	


func getDirection(angleRadians: float):
	var direction = Vector2(cos(angleRadians), sin(angleRadians))
	return direction

func dashAttack(direction):
	if pathfinding_component.isInVision() and canDash and not isDashing:
		tempMaxSpeed = dashSpeed
		isDashing = true

		velocity += direction * dashSpeed
		
		dashTimer.wait_time = dashDuration
		dashTimer.start()
		
		canDash = false
		cooldownTimer.wait_time = dashCooldown
		cooldownTimer.start()

func player_movement(_velocity):
	move_and_slide()
	
func accelerate(direction, delta):
	var xInput = pathfinding_component.sendMovement(self) * acceleration * delta
	velocity.x += xInput

	
	
	if abs(velocity.x) > tempMaxSpeed:
		velocity.x = direction.x * tempMaxSpeed
	if abs(velocity.y) > tempMaxSpeed:
		velocity.y = direction.y * tempMaxSpeed
		
	
	
	var frictionx = min(decelerationx * delta, abs(velocity.x))
	var frictiony = min(decelerationy * delta, abs(velocity.y))
	if velocity.x > 0:
		velocity.x = max(0, velocity.x - frictionx)
	elif velocity.x < 0:
		velocity.x = min(0, velocity.x + frictionx)
	
	if velocity.y > 0:
		velocity.y = max(0, velocity.y - frictiony)
	elif velocity.y < 0:
		velocity.y = min(0, velocity.y + frictiony)

func vectorToAngle(vector: Vector2) -> float:
	var angleToPlayer
	angleToPlayer = atan2(vector.y, vector.x)
	return angleToPlayer


