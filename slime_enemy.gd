extends CharacterBody2D

@export var speed := 45.0
@export var max_health := 2
@export var xp_reward := 1

var health := 0
var _player: Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("enemies")
	health = max_health
	animated_sprite_2d.play("default")
	_player = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(_player):
		return
	var dir := _player.global_position - global_position
	if dir.length_squared() > 1.0:
		velocity = dir.normalized() * speed
		move_and_slide()


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		_die()


func _die() -> void:
	get_tree().call_group("hud", "add_xp", xp_reward)
	queue_free()
