extends Node2D

@export var cell_size := 64.0
@export var area := Vector2(1152.0, 648.0)
@export var line_color := Color(1.0, 1.0, 1.0, 0.05)


func _draw() -> void:
	var x := 0.0
	while x <= area.x:
		draw_line(Vector2(x, 0.0), Vector2(x, area.y), line_color, 1.0)
		x += cell_size
	var y := 0.0
	while y <= area.y:
		draw_line(Vector2(0.0, y), Vector2(area.x, y), line_color, 1.0)
		y += cell_size