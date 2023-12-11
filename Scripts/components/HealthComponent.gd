extends Node2D
class_name HealthComponent

@onready var player = get_tree().get_first_node_in_group("player")
@onready var deathscreen = "res://Scenes/Death.tscn"
@export var MAX_HEALTH : float = 10.0
@onready var playerhitflash = get_tree().get_first_node_in_group("HitFlash")
var health : float

signal takeDamage
signal dieAnimation
signal bossDie
func _ready():
	if get_parent().is_in_group("player"):
		var global_script = get_node("/root/GlobalScript")
		health = global_script.get_player_health()
		print(health)
	else:
		health = MAX_HEALTH
	

func damage(attack: Attack):
	health -= attack.attack_damage
	emit_signal("takeDamage")
	if get_parent().is_in_group("player"):
		HurtSound.play()
		playerhitflash.play("hitflash")
	print(health)
	if health <= 0:
		die()


func die():
	emit_signal("dieAnimation")
	if get_parent().is_in_group("player"):
		await(get_tree().create_timer(0.5).timeout)
		SceneTransition.switch()
		get_tree().change_scene_to_file(deathscreen)
		GlobalScript.set_player_health(10)
		Randomizer.completedLevels = []
		Randomizer.levellist = [1,2,3,5,6,7,9,10]
		SceneTransition.end()
	elif get_parent().is_in_group("boss"):
		emit_signal("bossDie")
		await(get_tree().create_timer(1.6).timeout)
		get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")
		get_parent().queue_free()
	else:
		await(get_tree().create_timer(0.6).timeout)
		get_parent().queue_free()
	
