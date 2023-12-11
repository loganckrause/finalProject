extends Area2D


@export var speed = 400
@export var attackDamage = GlobalScript.attack_damage
@export var knockbackForce = 0
@export var stun_time = 1.5

func _ready():
	set_as_top_level(true)
	
func _process(delta):
	position += (Vector2.RIGHT*speed).rotated(rotation) * delta
	
	
func _physics_process(_delta):
	await(get_tree().create_timer(0.01))
	set_physics_process(false)
	

func _on_area_entered(body):
	print("Entered body class:", body.get_class())
	if body is HitboxComponent:
		var hitbox : HitboxComponent = body
		
		var attack = Attack.new()
		attack.attack_damage = attackDamage
		attack.knockback_force = knockbackForce
		
		hitbox.damage(attack)
		
		speed = 0
		$AnimatedSprite2D.play("collision")
		await(get_tree().create_timer(0.4).timeout)
		queue_free()
	elif body.get_name() == "wall":
		speed = 0
		$AnimatedSprite2D.play("collision")
		await(get_tree().create_timer(0.4).timeout)
		queue_free()

	# other stuff for the bullet
	# Animate explode or something
	# alive = false

	
