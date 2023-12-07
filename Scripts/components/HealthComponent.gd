extends Node2D
class_name HealthComponent

@onready var player = get_tree().get_first_node_in_group("player")

@export var MAX_HEALTH : float = 10.0
var health : float

func _ready():
	health = MAX_HEALTH
	print(health)

func damage(attack: Attack):
	health -= attack.attack_damage
	print(health)
	if health <= 0:
		die()


func die():
	if get_parent().is_in_group("player"):
		player.queue_free()
		Death.start()
		await(get_tree().create_timer(1.0).timeout)
		get_tree().change_scene_to_file("res://Scenes/Hub.tscn")
		Death.end()
	else:
		get_parent().queue_free()
	
