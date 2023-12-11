extends CharacterBody2D

@export var pathfinding_component: PathfindingComponent

@onready var player = get_tree().get_first_node_in_group("player")

const acceleration = 700
const decelerationx = 500
const decelerationy = 300

@export var maxSpeed = 70

var state_machine

var runIntoDamage: float = 3

var isDead = false

func _ready():
	$AnimationTree.active = true
	$AnimatedSprite2D.visible = false


func _physics_process(delta):
	state_machine = $AnimationTree.get("parameters/playback")
	
	$enemyWeapon.position = self.global_position
	
	accelerate(pathfinding_component.sendMovement(self), delta)
	player_movement(velocity)


	var dir = pathfinding_component.sendMovement(self)
	
	if isDead:
		velocity = Vector2.ZERO
		$HitboxComponent.monitorable = false
		
	if dir > 0:
		state_machine.travel('idle')
		$Sprite2D.set_flip_h(false)
	elif dir < 0:
		state_machine.travel('idle')
		$Sprite2D.set_flip_h(true)
	else: state_machine.travel('idle')
	



func player_movement(_velocity):
	move_and_slide()
	
func accelerate(direction, delta):
	var xInput = pathfinding_component.sendMovement(self) * acceleration * delta
	velocity.x += xInput
	
	var yInput = pathfinding_component.sendYMovement(self) * acceleration * delta
	velocity.y += yInput/2.33

	if abs(velocity.x) > maxSpeed:
		velocity.x = direction * maxSpeed
	
		
	var frictionx = min(decelerationx * delta, abs(velocity.x))
	var frictiony = min(decelerationy * delta, abs(velocity.y))
	
	if velocity.x > 0:
		velocity.x = max(0, velocity.x - frictionx)
	elif velocity.x < 0:
		velocity.x = min(0, velocity.x + frictionx)
	
	if velocity.y > 0:
		velocity.y = max(0, velocity.y - frictiony)
	elif velocity.y < 0:
		velocity.y = min(0, velocity.y + frictiony)



func _on_enemy_weapon_weapon_shot():
	var dir = pathfinding_component.sendMovement(self)
	if dir > 0:
		$Sprite2D.set_flip_h(false)
		state_machine.travel("attack")
	elif dir < 0:
		$Sprite2D.set_flip_h(true)
		state_machine.travel("attack")
	else: state_machine.travel("attack")


func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent and area.name == "PlayerHitboxComponent":
		var hitbox : HitboxComponent = area

		var attack = Attack.new()
		attack.attack_damage = runIntoDamage

		hitbox.damage(attack)
func _on_health_component_die_animation():
	isDead = true
	$AnimatedSprite2D.visible = true
	$Sprite2D.visible = false
	$AnimatedSprite2D.play("death")
