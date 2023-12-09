extends Node2D
class_name HealthComponent

@onready var player = get_tree().get_first_node_in_group("player")
@onready var deathscreen = "res://Scenes/Death.tscn"
@export var MAX_HEALTH : float = 10.0
@onready var playerhitflash = get_tree().get_first_node_in_group("HitFlash")
var health : float

func _ready():
	health = MAX_HEALTH
	print(health)

func damage(attack: Attack):
	health -= attack.attack_damage
	if get_parent().is_in_group("player"):
		playerhitflash.play("hitflash")
	print(health)
	if health <= 0:
		die()


func die():
	if get_parent().is_in_group("player"):
		await(get_tree().create_timer(1.0).timeout)
		SceneTransition.switch()
		get_tree().change_scene_to_file(deathscreen)
		SceneTransition.end()
	else:
		get_parent().queue_free()
	
