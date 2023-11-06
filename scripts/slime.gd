extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var mouseDeadZone = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _process(_delta):
	if get_global_mouse_position().x > $SlimeSprite.global_position.x:
		
		$SlimeSprite.set_flip_h(false)
		#if $SlimeSprite.global_position.distance_to(get_global_mouse_position()) > mouseDeadZone:
		$SlimeSprite/gun.set_flip_v(false)
		$SlimeSprite/gun.global_position = $SlimeSprite.global_position + Vector2(1,2)
	else:
		$SlimeSprite.set_flip_h(true)
		#if $SlimeSprite.global_position.distance_to(get_global_mouse_position()) > mouseDeadZone:
		$SlimeSprite/gun.set_flip_v(true)
		$SlimeSprite/gun.global_position = $SlimeSprite.global_position + Vector2(-1,2)
	pass


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	

	move_and_slide()
