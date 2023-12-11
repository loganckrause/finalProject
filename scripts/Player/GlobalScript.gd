extends Node

#Global Variables
var player_health: int = 10
var attack_damage = 3
var fire_rate = 0.4
var boss_health = 200

func get_player_health():
	return player_health
	
func set_player_health(health):
	player_health = health
