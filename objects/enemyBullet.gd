extends Area2D


@export var speed = 500
@export var attackDamage = 3
@export var knockbackForce = 0
@export var stun_time = 1.5

func _ready():
	set_as_top_level(true)
	
func _process(delta):
	position += (Vector2.RIGHT*speed).rotated(rotation) * delta
	
	
func _physics_process(delta):
	await(get_tree().create_timer(0.01))
	set_physics_process(false)
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Replace with function body.

func _on_area_entered(body):
	print("Entered body class:", body.get_class())
	if body is HitboxComponent:
		print("yuh")
		queue_free()
		var hitbox : HitboxComponent = body
		
		var attack = Attack.new()
		attack.attack_damage = attackDamage
		attack.knockback_force = knockbackForce
		
		hitbox.damage(attack)
		
	# other stuff for the bullet
	# Animate explode or something
	# alive = false

	
