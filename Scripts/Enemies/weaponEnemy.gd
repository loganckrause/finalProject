extends Sprite2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var playerPos = player.global_position
@onready var playerVector2 = Vector2(playerPos.x, playerPos.y)

@onready var bullet = preload("res://scenes/enemies/enemyBullet.tscn")

@export var vision_component : VisionComponent

var shootingInterval: float = 1
var shootTimer = Timer.new()

signal weaponShot

func _ready():
	if player:
		print("Player found!")
	
	shootTimer.set_one_shot(true)
	add_child(shootTimer)
	shootTimer.timeout.connect(_on_shootTimer_timeout)
	shootTimer.start()
	
	set_as_top_level(true)


func _process(_delta):
	if vision_component.isOverlapping():
		look_at(player.position)


func shoot():
	emit_signal("weaponShot")
	var bullet_instance = bullet.instantiate()
	bullet_instance.speed = 70
	bullet_instance.rotation = rotation
	bullet_instance.global_position = $muzzle.global_position
	get_parent().add_child(bullet_instance)
	
	shootTimer.wait_time = shootingInterval
	shootTimer.start()


func _on_shootTimer_timeout():
	shootTimer.start()
	if vision_component.isOverlapping():
		shoot()
