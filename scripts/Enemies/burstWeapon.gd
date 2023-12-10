extends Sprite2D


@onready var bullet = preload("res://scenes/enemies/enemyBullet.tscn")

@export var vision_component : VisionComponent

var shootingInterval: float = 2.5
var shootTimer = Timer.new()

signal weaponShot

func _ready():
	shootTimer.set_one_shot(true)
	add_child(shootTimer)
	shootTimer.timeout.connect(_on_shootTimer_timeout)
	shootTimer.start()
	
	set_as_top_level(true)


func _process(_delta):
	pass


func shoot():
	emit_signal("weaponShot")
	for i in range(8):
		var bullet_instance = bullet.instantiate()
		bullet_instance.speed = 70
		bullet_instance.rotation = i*0.785398
		bullet_instance.global_position = $muzzle.global_position
		get_parent().add_child(bullet_instance)
	
	shootTimer.wait_time = shootingInterval
	shootTimer.start()


func _on_shootTimer_timeout():
	shootTimer.start()
	if vision_component.isOverlapping():
		shoot()
