extends Node2D

@export var radius := 11.0
@export var color := Color(1.0, 1.0, 1.0, 0.9)


func _ready() -> void:
	z_as_relative = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()


func _draw() -> void:
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 24, color, 2.0)
	draw_line(Vector2(-radius - 5.0, 0.0), Vector2(-radius + 2.0, 0.0), color, 2.0)
	draw_line(Vector2(radius - 2.0, 0.0), Vector2(radius + 5.0, 0.0), color, 2.0)
	draw_line(Vector2(0.0, -radius - 5.0), Vector2(0.0, -radius + 2.0), color, 2.0)
	draw_line(Vector2(0.0, radius - 2.0), Vector2(0.0, radius + 5.0), color, 2.0)
	draw_circle(Vector2.ZERO, 1.5, color)