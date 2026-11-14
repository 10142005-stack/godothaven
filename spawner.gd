extends Node2D

const SLIME_SCENE := preload("res://slime.tscn")

# Difficulty curve: starts gentle, ramps up with time.
@export var start_interval := 1.8          # seconds between spawns at t=0 (easy start)
@export var min_spawn_interval := 0.2
@export var interval_decay := 0.02         # seconds shaved off the interval per second elapsed
@export var start_slime_speed := 45.0
@export var max_slime_speed := 95.0
@export var speed_gain := 0.9              # px/s added to slime speed per second elapsed
@export var spawn_radius := 370.0
@export var max_enemies := 160

var spawn_interval := 1.8
var elapsed := 0.0
var _cooldown := 0.0
var _active := true
var _player: Node2D


func _ready() -> void:
	add_to_group("spawner")
	_player = get_tree().get_first_node_in_group("player")
	spawn_interval = start_interval
	_cooldown = spawn_interval


func stop() -> void:
	_active = false


func _process(delta: float) -> void:
	if not _active or _player == null:
		return
	elapsed += delta
	spawn_interval = maxf(min_spawn_interval, start_interval - elapsed * interval_decay)
	_cooldown -= delta
	if _cooldown <= 0.0:
		_spawn()
		_cooldown = spawn_interval


func _spawn() -> void:
	if get_tree().get_nodes_in_group("enemies").size() >= max_enemies:
		return
	var angle := randf() * TAU
	var pos := _player.global_position + Vector2(cos(angle), sin(angle)) * spawn_radius
	pos.x = clampf(pos.x, 30.0, 1122.0)
	pos.y = clampf(pos.y, 30.0, 618.0)
	var slime := SLIME_SCENE.instantiate()
	slime.global_position = pos
	slime.set("speed", minf(max_slime_speed, start_slime_speed + elapsed * speed_gain))
	get_tree().get_first_node_in_group("enemies_container").add_child(slime)