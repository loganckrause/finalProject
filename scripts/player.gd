extends CharacterBody2D


const SPEED = 100
const JUMP_VELOCITY = -350

@onready var ap = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction != 0:
		ap.flip_h = direction == -1
		
	move_and_slide()
	
	update_animations(direction)
	
	_attacks()
func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			ap.play('idle')
	else:
		if velocity.y < 0:
			ap.play("jump")

func _attacks():
	var has_attacked = false
	if Input.is_action_just_pressed('attack'):
		ap.play("attack1")
		has_attacked = true
	elif Input.is_action_just_pressed('attack')
	
