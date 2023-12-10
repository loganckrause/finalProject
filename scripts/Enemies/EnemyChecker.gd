extends Area2D
signal enemies_gone
func _process(delta):
	if get_tree().get_nodes_in_group("Enemies").is_empty():
		emit_signal("enemies_gone")
