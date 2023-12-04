extends CharacterBody2D

@export var pathfinding_component: PathfindingComponent

const acceleration = 1000
const deceleration = 2000

var gravity = 980
var maxSpeed = 200

func _ready():
	pass

func _process(delta):
	$weaponEnemy.global_position = $EnemySprite.global_position + Vector2(0,0)
	
func _physics_process(delta):
	
	xaccelerate(pathfinding_component.sendMovement(self), delta)
	player_movement(velocity)
	jump(delta)

func player_movement(velocity):
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

func jump(delta):
	velocity.y += gravity * delta


