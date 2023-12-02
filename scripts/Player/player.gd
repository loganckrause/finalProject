extends CharacterBody2D

const acceleration = 1000
const deceleration = 2000

var gravity = 980
var maxSpeed = 200
const JUMP_VELOCITY = -300
var canDoubleJump = false

const WALL_JUMP_PUSH = 125
const WALL_SLIDE_FRICTION = 100
var is_wall_sliding = false

var dashSpeed: float = 800
var dashDuration: float = 0.2
var dashCooldown: float = 1
var dashTimer: float = 0
var canDash: bool = true

var mouseRight = true

var current_action = ""
var last_action = ""

@onready var marker = get_node("weapon/muzzle")

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _process(delta):
	$weapon.global_position = $PlayerSprite.global_position + Vector2(0,0)
	
	if get_global_mouse_position().x > $PlayerSprite.global_position.x:
		mouseRight = true
		$weapon.set_flip_v(false)
	else:
		mouseRight = false
		$weapon.set_flip_v(true)
	
	if Input.is_action_just_pressed("move_right"):
		current_action = "right"
	elif Input.is_action_just_pressed("move_left"):
		current_action = "left"
	else: pass

	if current_action != "":
		last_action = current_action
		current_action = ""
	
	# Mouse right Movement
	if mouseRight and Input.is_action_pressed("move_right"):
		$PlayerSprite.play("runningforw")
		$PlayerSprite.set_flip_h(false)

	elif mouseRight and Input.is_action_pressed("move_left"):
		$PlayerSprite.play("runningback")
		$PlayerSprite.set_flip_h(true)
	
	# Mouse left Movement
	elif !mouseRight and Input.is_action_pressed("move_right"):
		$PlayerSprite.play("runningback")
		$PlayerSprite.set_flip_h(false)
		
	elif !mouseRight and Input.is_action_pressed("move_left"):
		$PlayerSprite.play("runningforw")
		$PlayerSprite.set_flip_h(true)
	
	# Mouse right no Movement
	elif mouseRight and last_action == "right":
		$PlayerSprite.play("idlefacingforward")
		$PlayerSprite.set_flip_h(false)
	elif mouseRight and last_action == "left":
		$PlayerSprite.play("idlefacingback")
		$PlayerSprite.set_flip_h(true)
	
	# Mouse left no Movement
	elif !mouseRight and last_action == "left":
		$PlayerSprite.play("idlefacingforward")
		$PlayerSprite.set_flip_h(true)
	elif !mouseRight and last_action == "right":
		$PlayerSprite.play("idlefacingback")
		$PlayerSprite.set_flip_h(false)
	
	# Handling everything else
	else:
		$PlayerSprite.play("idlefacingforward")
	
	if dashTimer > 0:
		dashTimer -= delta
	else:
		canDash = true

func _physics_process(delta):
	# dir[0] = input_dir
	# dir[1] = xInput
	var inputDir = xinput()
	
	xaccelerate(inputDir, delta)
	player_movement(velocity)
	jump(delta)
	wall_slide(delta)
	dash()

func player_movement(velocity):
	move_and_slide()
	
func xaccelerate(direction, delta):
	var xInput = direction * acceleration * delta
	velocity.x += xInput
	if abs(velocity.x) > maxSpeed and dashTimer <= 0:
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
			canDoubleJump = true
			velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			if canDoubleJump and Input.is_action_just_pressed("jump"):
				canDoubleJump = false
				velocity.y = JUMP_VELOCITY
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

func dash():
	if canDash and Input.is_action_just_pressed("dash"):
		dashTimer = dashDuration
		velocity = Vector2.ZERO
		velocity.x = dashSpeed * xinput()
		
		canDash = false

		
