extends Area2D


const FILE_BEGIN = "res://Scenes/Level "

func _on_body_entered(body):
	if body.is_in_group("player"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		SceneTransition.switch()
		await(get_tree().create_timer(1.0).timeout)
		get_tree().change_scene_to_file(next_level_path)
		SceneTransition.end()

