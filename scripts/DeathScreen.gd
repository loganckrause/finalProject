extends CanvasLayer


func start():
	$AnimationPlayer.play("load")

func end():
	$AnimationPlayer.play_backwards("load")
