extends Node2D
class_name VisionComponent

var playerDetected: bool = false


func _ready():
	pass

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
