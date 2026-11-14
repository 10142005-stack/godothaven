extends Node2D

func _process(delta):
	$Weapon.position = $Player.position + Vector2(50, 0)
