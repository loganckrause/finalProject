extends AnimatedSprite2D

@onready var area : Area2D = $Area2D






func _on_area_2d_body_entered(body):
	play("open") 
	$Area2D/CollisionShape2D.queue_free()
