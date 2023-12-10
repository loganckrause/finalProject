extends Area2D

var enemies_gone = false
func _on_body_entered(body):
	if body.is_in_group("player") and enemies_gone == true:
		SceneTransition.switch()
		await(get_tree().create_timer(1.0).timeout)
		Randomizer.generate()
		SceneTransition.end()



func _on_enemy_checker_enemies_gone():
	enemies_gone = true
