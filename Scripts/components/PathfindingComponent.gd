extends Node2D
class_name PathfindingComponent

@export var vision_component: VisionComponent

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	pass 

func sendMovement(target) -> int:
	# X Movement
	var xInput: int
	if vision_component.isOverlapping():
		#print("vision")
		if player.global_position.x > target.global_position.x:
			xInput = 1
		elif player.global_position.x < target.global_position.x:
			xInput = -1
		else:
			xInput = 0
	return xInput
	
func sendYMovement(target) -> int:
	# Y Movement
	var yInput: int
	if vision_component.isOverlapping():
		#print("vision")
		if player.global_position.y > target.global_position.y:
			yInput = 1
		elif player.global_position.y < target.global_position.y:
			yInput = -1
		else:
			yInput = 0
	return yInput

func getDistanceBetweenTargets(target1: Vector2, target2: Vector2) -> Vector2:
	var distance = target2 - target1
	return distance

func isInVision():
	if vision_component.isOverlapping():
		return true
	else:
		return false
