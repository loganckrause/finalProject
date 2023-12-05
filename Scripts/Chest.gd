extends Area2D

@onready var chest = get_tree().get_first_node_in_group("Chest")

func _on_body_entered(body):
	if body.is_in_group("player"):
		chest.play("open")
		$CollisionShape2D.queue_free()
		
		
