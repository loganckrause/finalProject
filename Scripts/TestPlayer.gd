extends CharacterBody2D

const SPEED = 200
const JUMP_VELOCITY = -400
const GRAVITY = 600

var hasJumped = false

func _physics_process(delta):

	velocity.y += GRAVITY * delta


	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		hasJumped = true
	if Input.is_action_just_pressed("ui_accept") and hasJumped == true:
		velocity.y += -300
		hasJumped = false
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


		
	
func die():
	queue_free()


func _on_kill_area_body_entered(body):
	die()
