extends Node2D
class_name HealthComponent

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
	# add logic for death
	get_parent().queue_free()
	
