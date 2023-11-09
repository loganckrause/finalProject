extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var mouseDeadZone = 5
@onready var marker = get_node("weapon/muzzle")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _process(_delta):
	if get_global_mouse_position().x > $SlimeSprite.global_position.x:
		$SlimeSprite.set_flip_h(false)
		$weapon.set_flip_v(false)
		$weapon/hand.set_flip_v(false)
		$weapon.global_position = $SlimeSprite.global_position + Vector2(2,1)
		$weapon/hand.global_position = $weapon.global_position + Vector2(2,1)
	else:
		$SlimeSprite.set_flip_h(true)
		$weapon.set_flip_v(true)
		$weapon/hand.set_flip_v(true)
		$weapon.global_position = $SlimeSprite.global_position + Vector2(-2,1)
		$weapon/hand.global_position = $weapon.global_position + Vector2(-2,1)
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
