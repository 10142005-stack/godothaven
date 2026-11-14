extends CharacterBody2D

const BULLET_SCENE := preload("res://bullet.tscn")

@export var speed := 240.0
@export var max_health := 100.0
@export var contact_damage_per_second := 18.0
@export var fire_interval := 0.28
@export var bullet_speed := 560.0
@export var bullet_damage := 1
@export var muzzle_time := 0.06
@export var bullet_spawn_offset := 60.0

var health := 0.0
var dead := false
var _fire_cooldown := 0.0
var _muzzle_timer := 0.0
var _aim_dir := Vector2.RIGHT

@onready var weapon: Node2D = $Weapon
@onready var muzzle_flash: Sprite2D = $Weapon/MuzzleFlash


func _ready() -> void:
	add_to_group("player")
	health = max_health
	muzzle_flash.visible = false


func _physics_process(delta: float) -> void:
	if _muzzle_timer > 0.0:
		_muzzle_timer -= delta
		if _muzzle_timer <= 0.0:
			muzzle_flash.visible = false

	_fire_cooldown = maxf(0.0, _fire_cooldown - delta)
	if dead:
		return

	var move := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move * speed
	move_and_slide()

	# Aim with the mouse; the gun points at the cursor.
	_aim_dir = (get_global_mouse_position() - global_position).normalized()
	if _aim_dir.length_squared() < 0.001:
		_aim_dir = Vector2.RIGHT
	weapon.rotation = _aim_dir.angle()

	# Shoot ourselves: hold left mouse (or Space) to fire.
	if Input.is_action_pressed("shoot"):
		_try_fire()

	_contact_damage(delta)


func _try_fire() -> void:
	if _fire_cooldown > 0.0:
		return
	_fire_cooldown = fire_interval
	var bullet := BULLET_SCENE.instantiate()
	bullet.direction = _aim_dir
	bullet.rotation = _aim_dir.angle()
	bullet.speed = bullet_speed
	bullet.damage = bullet_damage
	bullet.global_position = global_position + _aim_dir * bullet_spawn_offset
	get_tree().get_first_node_in_group("projectiles").add_child(bullet)

	muzzle_flash.visible = true
	_muzzle_timer = muzzle_time


func _contact_damage(delta: float) -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if global_position.distance_to(enemy.global_position) < 30.0:
			take_damage(contact_damage_per_second * delta)
			break


func take_damage(amount: float) -> void:
	if dead:
		return
	health = maxf(0.0, health - amount)
	if health <= 0.0:
		_die()


func _die() -> void:
	dead = true
	velocity = Vector2.ZERO
	get_tree().call_group("hud", "show_game_over")


func on_level_up() -> void:
	fire_interval = maxf(0.12, fire_interval * 0.92)
	bullet_damage += 1
