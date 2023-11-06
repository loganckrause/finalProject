extends Area2D

var dead = false
var take_damage = false
var damage_count = 0

func _ready():
	pass


func _process(delta):
	if dead == false and take_damage == false:
		$AnimatedSprite2D.play("idle")


func _on_area_entered(area):
	if area.is_in_group("sword"):
		take_damage = true
		damage_count += 1
		$AnimatedSprite2D.play("damage")
	if damage_count == 3:
		dead = true
		$AnimatedSprite2D.play("death")



func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		queue_free()
	elif $AnimatedSprite2D.animation == "damage":
		take_damage = false

