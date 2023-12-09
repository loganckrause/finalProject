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

var tempMaxSpeed = maxSpeed
var dashSpeed: float = 600
var dashCooldown: float = 2
var dashDuration: float = 0.6
var isDashing = false
var canDash = true
var dashDurationTimer = Timer.new()
var cooldownTimer = Timer.new()

var animationFinished = false

var mouseRight = true

var current_action = ""
var last_action = ""

signal dashingSignal

var state_machine

var isJumping = false
var isDoubleJump = false
var isFalling = false

@onready var marker = get_node("weapon/muzzle")
@export var health_component : HealthComponent
# Get the gravity from the project settings to be synced with RigidBody nodes.
func _ready():
	dashDurationTimer.set_one_shot(true)
	cooldownTimer.set_one_shot(true)
	add_child(dashDurationTimer)
	add_child(cooldownTimer)
	dashDurationTimer.timeout.connect(_on_dashDurationTimer_timeout)
	cooldownTimer.timeout.connect(_on_cooldownTimer_timeout)
	
	
	$AnimationTree.active = true

func _on_dashDurationTimer_timeout():
	tempMaxSpeed = maxSpeed
	isDashing = false

func _on_cooldownTimer_timeout():
	canDash = true

func update_animation():
	var left: bool
	var right: bool
	if Input.is_action_pressed("move_right"):
		right = true
		left = false
	elif Input.is_action_pressed("move_left"):
		left = true
		right = false
	else:
		right = false
		left = false
	
	if health_component.health < 0:
		state_machine.travel("death")
	
	if is_wall_sliding:
		state_machine.travel("wall_slide")
		if left:
			$Sprite.set_flip_h(false)
		elif right:
			$Sprite.set_flip_h(true)

	if isDashing:
		velocity.y = 0
		state_machine.travel("dash")
		if left:
			$Sprite.set_flip_h(true)
		elif right:
			$Sprite.set_flip_h(false)
			
	if isJumping:
		state_machine.travel("jump")
		if left:
			$Sprite.set_flip_h(true)
		elif right:
			$Sprite.set_flip_h(false)
	
	if isDoubleJump:
		state_machine.travel("double_jump")
		if left:
			$Sprite.set_flip_h(true)
		elif right:
			$Sprite.set_flip_h(false)
			
	if isFalling:
		state_machine.travel("falling")
		if left:
			$Sprite.set_flip_h(true)
		elif right:
			$Sprite.set_flip_h(false)
	

func _process(delta):
	
	state_machine = $AnimationTree.get("parameters/playback")
	
	$weapon.global_position = $Sprite.global_position + Vector2(0,0)
	
	if get_global_mouse_position().x > $Sprite.global_position.x:
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
		state_machine.travel("run_right")
		$Sprite.set_flip_h(false)

	elif mouseRight and Input.is_action_pressed("move_left"):
		state_machine.travel("run_left")
		$Sprite.set_flip_h(true)
	
	# Mouse left Movement
	elif !mouseRight and Input.is_action_pressed("move_right"):
		state_machine.travel("run_left")
		$Sprite.set_flip_h(false)
		
	elif !mouseRight and Input.is_action_pressed("move_left"):
		state_machine.travel("run_right")
		$Sprite.set_flip_h(true)
	
	# Mouse right no Movement
	elif mouseRight and last_action == "right":
		state_machine.travel("idle_right")
		$Sprite.set_flip_h(false)
	elif mouseRight and last_action == "left":
		state_machine.travel("idle_left")
		$Sprite.set_flip_h(true)
	
	# Mouse left no Movement
	elif !mouseRight and last_action == "left":
		state_machine.travel("idle_right")
		$Sprite.set_flip_h(true)
	elif !mouseRight and last_action == "right":
		state_machine.travel("idle_left")
		$Sprite.set_flip_h(false)
	
	# Handling everything else
	else:
		state_machine.travel("idle_right")
	
	update_animation()

func _physics_process(delta):
	# dir[0] = input_dir
	# dir[1] = xInput
	var inputDir = xinput()
	
	xaccelerate(inputDir, delta)
	player_movement(velocity)
	jump(delta)
	wall_slide(delta)
	dashAttack()

func dashAttack():
	if Input.is_action_just_pressed("dash") and canDash and not isDashing:
		tempMaxSpeed = dashSpeed
		isDashing = true
		emit_signal("dashingSignal")
		# Apply Movement
		#velocity = Vector2.ZERO
		velocity.x += xinput() * dashSpeed
		
		dashDurationTimer.wait_time = dashDuration
		dashDurationTimer.start()
		
		canDash = false
		cooldownTimer.wait_time = dashCooldown
		cooldownTimer.start()

func player_movement(_velocity):
	move_and_slide()
	
func xaccelerate(direction, delta):
	var xInput = direction * acceleration * delta
	velocity.x += xInput
	if abs(velocity.x) > tempMaxSpeed:
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
			isJumping = true
			canDoubleJump = true
			velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			if canDoubleJump and Input.is_action_just_pressed("jump"):
				canDoubleJump = false
				isDoubleJump = true
				velocity.y = JUMP_VELOCITY
			if is_on_wall() and Input.is_action_pressed("move_left"):
				velocity.y = JUMP_VELOCITY 
				velocity.x = WALL_JUMP_PUSH
			if is_on_wall() and Input.is_action_pressed("move_right"):
				velocity.y = JUMP_VELOCITY
				velocity.x = -WALL_JUMP_PUSH
	elif not is_on_floor():
		isFalling = true
	
	if is_on_floor():
		isJumping = false
		isDoubleJump = false
		isFalling = false
	if is_wall_sliding:
		isFalling = false
		isDoubleJump = false
	if isDoubleJump:
		isFalling = false
		isJumping = false
	if isJumping:
		isFalling = false
		isDoubleJump = false
	if isDashing:
		isFalling = false
		isDoubleJump = false

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

func _input(event : InputEvent):
	if(event.is_action_pressed("down") && is_on_floor()):
		position.y += 1

		
