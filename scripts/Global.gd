extends Node

var playerPath: NodePath = ""
var emptyPath: NodePath = ""

func setPlayerPath(path: NodePath) -> void:
	playerPath = path

func getPlayerNode() -> Node:
	if playerPath != emptyPath:
		return get_node(playerPath)
	else:
		return null
