extends Sprite2D


@onready var bullet = preload("res://scenes/enemies/enemyBullet.tscn")
@onready var wallbullet = preload("res://scenes/enemies/enemyBullet.tscn")

@export var vision_component : VisionComponent
@export var pathfinding_component: PathfindingComponent

var shootingInterval: float = 2.5
var shootTimer = Timer.new()

var attackRotation: float

signal burstShot
signal bulletWallShot

var burstTimer = Timer.new()
var burstInterval: float = 5
var wallBurstTimer = Timer.new()
var wallBurstInterval: float = 7

var isBursting = false
var isWallBursting = false

signal wall
signal burst

func make_timers():
	burstTimer.set_one_shot(true)
	wallBurstTimer.set_one_shot(true)
	
	add_child(burstTimer)
	add_child(wallBurstTimer)
	
	burstTimer.timeout.connect(_on_burstTimer_timeout)
	wallBurstTimer.timeout.connect(_on_wallBurstTimer_timeout)
	
	burstTimer.wait_time = burstInterval
	wallBurstTimer.wait_time = wallBurstInterval
	burstTimer.start()
	wallBurstTimer.start()

func _on_burstTimer_timeout():
	burstShoot()
func _on_wallBurstTimer_timeout():
	bulletWallShoot()

func _ready():
	make_timers()
	set_as_top_level(true)

func _process(_delta):
	if pathfinding_component.sendMovement(self) > 0:
		attackRotation = 0
	elif pathfinding_component.sendMovement(self) < 0:
		attackRotation = PI

func burstShoot():
	emit_signal("burst")
	burstTimer.start()
	burstTimer.wait_time = burstInterval
	for i in range(8):
		var bullet_instance = bullet.instantiate()

		bullet_instance.speed = 70
		bullet_instance.rotation = i*PI/4
		bullet_instance.global_position = $muzzle.global_position
		get_parent().add_child(bullet_instance)

func bulletWallShoot():
	emit_signal("wall")
	wallBurstTimer.start()
	wallBurstTimer.wait_time = wallBurstInterval
	for wave in range(2):
		for i in range(6):
			var bullet_instance = bullet.instantiate()
			bullet_instance.speed = 70
			bullet_instance.rotation = (((i-2))*PI/24) + attackRotation
			bullet_instance.global_position = $muzzle.global_position
			get_parent().add_child(bullet_instance)
		await(get_tree().create_timer(0.8).timeout)
	
