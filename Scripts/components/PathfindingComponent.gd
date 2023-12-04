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

