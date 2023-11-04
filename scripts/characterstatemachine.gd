extends Node

class_name CharacterStateMachine

@export var current_state : state

@export var states : Array[state]

func _ready():
	for child in get_children():
		if(child is state):
			states.append(child)
		else:
			push_warning("Child" + child.name + "is not a state for CharacterStateMachine")
		
func check_if_can_move():
	return current_state.can_move
	
