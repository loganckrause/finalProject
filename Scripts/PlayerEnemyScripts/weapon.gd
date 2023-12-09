extends Sprite2D


var cooltime = 0.4
@onready var bullet = preload("res://Scenes/PlayerStuff/bullet.tscn")


func _ready():
	set_as_top_level(true)
	$FiringCooldown.wait_time = cooltime



func _physics_process(_delta):
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)

func _process(_delta):
	
	if Input.is_action_pressed("fire") and $FiringCooldown.is_stopped():
		shoot()

func shoot():
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation = rotation
	bullet_instance.global_position = $muzzle.global_position
	get_parent().add_child(bullet_instance)
	
	$FiringCooldown.start()
