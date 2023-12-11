extends Area2D





func _on_body_entered(body):
	if body.is_in_group("player"):
		GlobalScript.fire_rate = 0.2
		$AnimatedSprite2D.visible = false
		$Label.visible = true
		await(get_tree().create_timer(1.5).timeout)
		$Label.visible = false
