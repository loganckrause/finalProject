extends Area2D


func _on_body_entered(body):
	if body.is_in_group("player"):
		GlobalScript.player_health = 10
		$AnimatedSprite2D.visible = false
