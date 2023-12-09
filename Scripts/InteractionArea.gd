extends Area2D

@onready var label : Label = $Label
@onready var portal : AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var portalbox = $"../AnimatedSprite2D/Area2D/CollisionShape2D"
@onready var portalsound = $"../AudioStreamPlayer2D"

func _ready():
	label.hide()
	portal.visible = false
	

func _on_body_entered(body):
	if body.is_in_group("player"):
		label.show()

func _input(event) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("interact"):
			portalbox.disabled = false
			portalsound.play()
			portal.visible = true
	
	
	


func _on_body_exited(_body):
	label.hide()
