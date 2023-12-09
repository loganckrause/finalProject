extends Node
@onready var levellist = [1,2,3,5,6,7,9]
@onready var levelChoice = levellist.pick_random()
@onready var completedLevels = []
@onready var staticLevels = [4,8,10]
@onready var nextLevel = null
func generate():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var completed_level = current_scene_file.to_int()
	completedLevels.append(completed_level)
	levellist.erase(completed_level)
	while levelChoice in completedLevels:
		levelChoice = levellist.pick_random()
	if len(completedLevels) == 3:
		nextLevel = 4
	elif len(completedLevels) == 7:
		nextLevel = 8
	elif len(completedLevels) == 9:
		nextLevel = 10
	else:
		nextLevel = levelChoice
	return get_tree().change_scene_to_file("res://Scenes/Level " + str(nextLevel) + ".tscn")
