extends CharacterBody2D

const SPEED = 200
const JUMP_VELOCITY = -400.0


func _physics_process(delta):

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("ui_up"):
		velocity.y = 1 * SPEED
	
	if Input.is_action_just_pressed("ui_down"):
		velocity.y = -1 * SPEED
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


		
	
	
