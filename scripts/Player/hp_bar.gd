extends TextureProgressBar

@onready var bar = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	bar.value = GlobalScript.get_player_health()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bar.value = GlobalScript.get_player_health()
