extends CanvasLayer

@onready var animation_player = $AnimationPlayer


func switch():
	animation_player.play("dissolve")
	
	

func end():
	animation_player.play_backwards("dissolve")
