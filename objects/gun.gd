extends Sprite2D



var can_fire = true
@onready var bullet = preload("res://objects/bullet.tscn")


func _ready():
	set_as_top_level(true)



func _physics_process(_delta):
	"""position.x = lerp(position.x, get_parent().position.x, 0.75)
	position.y = lerp(position.y, get_parent().position.y, 0.75)"""
	
	var mouse_pos = get_global_mouse_position()
	
	
	look_at(mouse_pos)
	
"""	if Input.is_action_pressed("fire"):
		var bullet_instance = bullet.instance()
		bullet_instance.rotation = rotation
		
		"""
