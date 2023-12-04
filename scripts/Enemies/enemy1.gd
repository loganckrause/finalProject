extends CharacterBody2D

func _process(delta):
	$weaponEnemy.global_position = $EnemySprite.global_position + Vector2(0,0)
