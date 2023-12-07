extends Area2D
@onready var randomnum = ceil(randi_range(0,2))
@onready var chest = get_tree().get_first_node_in_group("Chest")
@onready var potion1 = $"../../SpeedPotion/AnimatedSprite2D"
@onready var collision1 = $"../../SpeedPotion/CollisionShape2D"
@onready var animation_player1 = $"../../SpeedPotion/AnimationPlayer"
@onready var area1 = $"../../SpeedPotion"
@onready var potion2 = $"../../AttackPotion/AnimatedSprite2D"
@onready var collision2 = $"../../AttackPotion/CollisionShape2D"
@onready var animation_player2 = $"../../AttackPotion/AnimationPlayer"



func _on_body_entered(body):
	if body.is_in_group("player"):
		chest.play("open")
		$CollisionShape2D.queue_free()


func _on_chest_animation_finished():
	if randomnum == 1:
		collision1.disabled = false
		potion1.play("default")
		animation_player1.play("bounce")
		potion1.visible = true
	else:
		collision2.disabled = false
		potion2.play("default")
		animation_player2.play("bounce")
		potion2.visible = true

