extends Node2D
@onready var deathsound = $AudioStreamPlayer2D
func _ready():
	Maingameaudio.stop()
	deathsound.play()
	await(get_tree().create_timer(6.0).timeout)
	SceneTransition.switch()
	get_tree().change_scene_to_file("res://Scenes/Hub.tscn")
	SceneTransition.end()

