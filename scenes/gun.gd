extends Sprite2D

@onready var sprite = $gun

var can_fire = true
var bullet = preload("res://objects/bullet.tscn")

func _ready():
	set_as_top_level(true)
	
func _physics_process(delta):
	position.x = lerp(position.x, get_parent().position.x, 0.5)
	position.y = lerp(position.y, get_parent().position.y, 0.5)
	var mouse_pos = get_global_mouse_position()
	#if get_global_mouse_position().x < position.x:
	#	sprite.flip_v = true
	
	look_at(mouse_pos)
	
	if Input.is_action_pressed("fire"):
		var bullet_instance = bullet.instance()
		bullet_instance.rotation = rotation
		
		
