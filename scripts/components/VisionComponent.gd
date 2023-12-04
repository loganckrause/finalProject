extends Area2D
class_name VisionComponent

var playerDetected: bool = false

func _process(delta):
	pass

func isOverlapping():
	var overlappingBodies = get_overlapping_areas()
	if overlappingBodies.size() > 0:
		for body in overlappingBodies:
			if body.name == "PlayerHitboxComponent":
				return true
	return false

func _on_area_entered(area):
	if area.name == "PlayerHitboxComponent":
		playerDetected = true
		print("player detected")

func _on_area_exited(area):
	if area.name == "PlayerHitboxComponent":
		playerDetected = false
		print("player exited")

func isPlayerDetected() -> bool:
	return playerDetected
