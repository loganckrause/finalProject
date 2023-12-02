extends CharacterBody2D


const acceleration = 2000
const deceleration = 1000

var gravity = 980
const maxSpeed = 200
const JUMP_VELOCITY = -300
var canDoubleJump = false

const WALL_JUMP_PUSH = 175
const WALL_SLIDE_FRICTION = 100
var is_wall_sliding = false



# Get the gravity from the project settings to be synced with RigidBody nodes.



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
	var inputDir = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	return inputDir

func jump(delta):
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			canDoubleJump = true
			velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			if canDoubleJump and Input.is_action_just_pressed("jump"):
				canDoubleJump = false
				velocity.y = JUMP_VELOCITY
			if is_on_wall() and Input.is_action_pressed("left"):
				velocity.y = JUMP_VELOCITY 
				velocity.x = WALL_JUMP_PUSH
			if is_on_wall() and Input.is_action_pressed("right"):
				velocity.y = JUMP_VELOCITY
				velocity.x = -WALL_JUMP_PUSH

func wall_slide(delta):
	if is_on_wall() and not is_on_floor():
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		velocity.y += (WALL_SLIDE_FRICTION * delta)
		velocity.y = min(velocity.y, WALL_SLIDE_FRICTION)
		
	pass

func _input(event : InputEvent):
	if(event.is_action_pressed("down") && is_on_floor()):
		position.y += 1
