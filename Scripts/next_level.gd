extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		SceneTransition.switch()
		await(get_tree().create_timer(1.0).timeout)
		Randomizer.generate()
		SceneTransition.end()

