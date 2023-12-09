extends Control


@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var exit_button =  $MarginContainer/HBoxContainer/VBoxContainer/ExitButton as Button
@onready var start_level = preload("res://Scenes/Hub.tscn") as PackedScene
@onready var audio = $AudioStreamPlayer

func _ready():
	Maingameaudio.stop()
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	audio.play()
	
func on_start_pressed():
	
	SceneTransition.switch()
	await(get_tree().create_timer(1.0).timeout)
	get_tree().change_scene_to_packed(start_level)
	SceneTransition.end()
func on_exit_pressed():
	get_tree().quit()
