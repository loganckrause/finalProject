extends Area2D

@onready var health_component : HealthComponent
@onready var sprite = $AnimatedSprite2D
func _on_body_entered(body):
	if body.is_in_group("player"):
		sprite.visible = false
	
