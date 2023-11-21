extends CharacterBody2D

const friction = 70
const acceleration = 1000
const deceleration = 2000
const maxSpeed = 200
const JUMP_VELOCITY = -300
var mouseDeadZone = 5
const WALL_JUMP_PUSH = 125
const WALL_SLIDE_FRICTION = 100
var is_wall_sliding = false
@onready var marker = get_node("weapon/muzzle")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _process(delta):
	if get_global_mouse_position().x > $SlimeSprite.global_position.x:
		$SlimeSprite.set_flip_h(false)
		$weapon.set_flip_v(false)
		$weapon/hand.set_flip_v(false)
		$weapon.global_position = $SlimeSprite.global_position + Vector2(0,0)
		$weapon/hand.global_position = $weapon.global_position + Vector2(0,0)
	else:
		$SlimeSprite.set_flip_h(true)
		$weapon.set_flip_v(true)
		$weapon/hand.set_flip_v(true)
		$weapon.global_position = $SlimeSprite.global_position + Vector2(0,0)
		$weapon/hand.global_position = $weapon.global_position + Vector2(0,0)
	pass

func _physics_process(delta):
	# dir[0] = input_dir
	# dir[1] = xInput
	var inputDir = xinput()
	
	xaccelerate(inputDir, delta)
	player_movement(velocity)
	jump(delta)
	wall_slide(delta)


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


func xinput():
	var inputDir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	return inputDir
func jump(delta):
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			if is_on_wall() and Input.is_action_pressed("move_left"):
				velocity.y = JUMP_VELOCITY 
				velocity.x = WALL_JUMP_PUSH
			if is_on_wall() and Input.is_action_pressed("move_right"):
				velocity.y = JUMP_VELOCITY
				velocity.x = -WALL_JUMP_PUSH
	
func wall_slide(delta):
	if is_on_wall() and not is_on_floor():
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		velocity.y += (WALL_SLIDE_FRICTION * delta)
		velocity.y = min(velocity.y, WALL_SLIDE_FRICTION)
		
	pass

