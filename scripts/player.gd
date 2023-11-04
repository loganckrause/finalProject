extends CharacterBody2D

@export var speed : float = 100.0
@export var jump_velocity : float = -200.0
@export var double_jump_velocity : float = -150.0

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped = false
var animation_locked = false
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false

func _ready():
	animation_tree.active = true


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		has_double_jumped = false
		
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		elif not has_double_jumped:
			double_jump()
	
	direction = Input.get_vector("move_left", "move_right", "jump", "down")
	
	if direction.x != 0 && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	
	move_and_slide()
	update_animation()
	update_facing_direction()


func update_animation():
	animation_tree.set("parameters/Move/blend_position", direction.x)
	
func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
func jump():
	velocity.y = jump_velocity
	animation_locked = true
	
func double_jump():
	velocity.y = double_jump_velocity
	animation_locked = true
	has_double_jumped = true
