extends CharacterBody2D


@export var speed = 150
@export var jump_velocity = -250
@export var double_jump_velocity = -200

@onready var asprite : AnimatedSprite2D = $AnimatedSprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var isAttacking = false

	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			has_double_jumped = false
		elif has_double_jumped ==false:
			velocity.y = double_jump_velocity
			has_double_jumped = true

	if Input.is_action_just_pressed("attack"):
		asprite.play("attack1")
		isAttacking = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("move_left", "move_right", "jump", "down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	animation_facing()
	
func update_animation():
	if is_on_floor():
		if direction.x != 0 and isAttacking == false:
			asprite.play("run")
		elif direction.x == 0 and isAttacking == false:
			asprite.play("idle")
	elif isAttacking == false:
		if velocity.y < 0:
			asprite.play("jump")
		else:
			asprite.play("fall")
	if Input.is_action_just_pressed("attack"):
		asprite.play("attack1")
		isAttacking = true
		$AttackArea/CollisionShape2D.disabled = false
func animation_facing():
	if direction.x > 0:
		$CollisionShape2D.position.x = -5.5
		$AttackArea/CollisionShape2D.position.x = 30
		asprite.flip_h = false
	elif direction.x < 0:
		$CollisionShape2D.position.x = 5.5
		$AttackArea/CollisionShape2D.position.x = -30
		asprite.flip_h = true


func _on_animated_sprite_2d_animation_finished():
	if asprite.animation == "attack1":
		$AttackArea/CollisionShape2D.disabled = true
		isAttacking = false
		
func attack():
	isAttacking = true
	asprite.play("attack1")

