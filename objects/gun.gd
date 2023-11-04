extends Sprite2D

@onready var sprite = $gun

var can_fire = true
var bullet = preload("res://objects/bullet.tscn")

func _ready():
	set_as_top_level(true)

func _process(delta):
	
	if get_global_mouse_position().x > get_parent().global_position.x:
		set_flip_v(false)
		sprite.position = get_parent().position.x-10
	else:
		set_flip_v(true)
		sprite.position = get_parent().position.x-10
	pass


func _physics_process(delta):
	"""position.x = lerp(position.x, get_parent().position.x, 0.75)
	position.y = lerp(position.y, get_parent().position.y, 0.75)"""
	
	var mouse_pos = get_global_mouse_position()
	
	
	look_at(mouse_pos)
	
	if Input.is_action_pressed("fire"):
		var bullet_instance = bullet.instance()
		bullet_instance.rotation = rotation
		
		
