extends Area2D


func _on_body_entered(body):
	if body.is_in_group("player"):
		SceneTransition.switch()
		await(get_tree().create_timer(1.0).timeout)
		get_tree().change_scene_to_file("res://Scenes/Level 1.tscn")
		Maingameaudio.play()
		SceneTransition.end()
