extends Sprite2D


var cooltime = 0.2
@onready var bullet = preload("res://objects/bullet.tscn")
var player
var global

func _ready():
	#var player = get_node("res://scripts/player.gd")
	
	if player:
		print("Player found!")
	
	
	set_as_top_level(true)
	$FiringCooldown.wait_time = cooltime

func _physics_process(_delta):
	#look_at(player)
	pass

func _process(delta):
	if $FiringCooldown.is_stopped():
		shoot()

func shoot():
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation = rotation
	bullet_instance.global_position = $muzzle.global_position
	get_parent().add_child(bullet_instance)
	
	$FiringCooldown.start()
