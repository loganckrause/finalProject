extends Sprite2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var playerPos = player.global_position
@onready var playerVector2 = Vector2(playerPos.x, playerPos.y)

@onready var bullet = preload("res://Scenes/PlayerStuff/enemyBullet.tscn")

@export var vision_component : VisionComponent

var shoot_timer

func _ready():
	if player:
		print("Player found!")
	
	shoot_timer = $FiringCooldown
	
	shoot_timer.start()
	
	set_as_top_level(true)
	

func _process(_delta):
	if vision_component.isOverlapping():
		look_at(player.position)


func shoot():
	var bullet_instance = bullet.instantiate()
	bullet_instance.speed = 50
	bullet_instance.rotation = rotation
	bullet_instance.global_position = $muzzle.global_position
	get_parent().add_child(bullet_instance)
	
	shoot_timer.start()


func _on_firing_cooldown_timeout():
	if vision_component.isOverlapping():
		shoot()
