extends Sprite2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var playerPos = player.global_position
@onready var playerVector2 = Vector2(playerPos.x, playerPos.y)

@onready var visionComponent = get_node("VisionComponent")

var cooltime = 0.2
@onready var bullet = preload("res://objects/bullet.tscn")


func _ready():
	if player:
		print("Player found!")
	
	
	
	set_as_top_level(true)
	$FiringCooldown.wait_time = cooltime

func _process(delta):
	var overlappingBodies = visionComponent.get_overlapping_areas()
	if overlappingBodies.size() > 0:
		for body in overlappingBodies:
			if body.is_class("HitboxComponent"):
				print("yo")


func shoot():
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation = rotation
	bullet_instance.global_position = $muzzle.global_position
	get_parent().add_child(bullet_instance)
	
	$FiringCooldown.start()


func _on_vision_component_area_entered(area):
	look_at(player.position)
	if $FiringCooldown.is_stopped():
		shoot()
