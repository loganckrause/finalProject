extends Area2D

@onready var chest = get_tree().get_first_node_in_group("Chest")
@onready var potion = $"../../HealthPotion/AnimatedSprite2D"
@onready var animation_player = $"../../HealthPotion/AnimationPlayer"
@onready var area = $"../../HealthPotion"
@onready var collision = $"../../HealthPotion/CollisionShape2D"



func _on_body_entered(body):
	if body.is_in_group("player"):
		chest.play("open")
		$CollisionShape2D.queue_free()


func _on_chest_animation_finished():
	collision.disabled = false
	potion.play("default")
	animation_player.play("bounce")
	potion.visible = true
