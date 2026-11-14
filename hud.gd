extends CanvasLayer

@onready var xp_bar: ProgressBar = $Root/XPBar
@onready var xp_label: Label = $Root/XPBar/Label
@onready var level_label: Label = $Root/LevelLabel
@onready var health_bar: ProgressBar = $Root/HealthBar
@onready var health_label: Label = $Root/HealthBar/HealthLabel
@onready var game_over_label: Label = $Root/GameOver

var xp := 0
var xp_max := 5
var level := 1
var kills := 0


func _ready() -> void:
	add_to_group("hud")
	game_over_label.visible = false
	var player := get_tree().get_first_node_in_group("player")
	if player:
		health_bar.max_value = player.max_health
		health_bar.value = player.health
		health_label.text = "HP %d / %d" % [roundi(player.health), roundi(player.max_health)]
	_update()


func add_xp(amount: int) -> void:
	xp += amount
	kills += 1
	while xp >= xp_max:
		xp -= xp_max
		level += 1
		xp_max = int(xp_max * 1.35) + 1
		get_tree().call_group("player", "on_level_up")
	_update()


func show_game_over() -> void:
	game_over_label.visible = true
	get_tree().call_group("spawner", "stop")


func _process(_delta: float) -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player:
		health_bar.value = player.health
		health_label.text = "HP %d / %d" % [roundi(player.health), roundi(player.max_health)]
	if game_over_label.visible and Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()


func _update() -> void:
	xp_bar.max_value = xp_max
	xp_bar.value = xp
	xp_label.text = "XP %d / %d" % [xp, xp_max]
	level_label.text = "Lv %d    Kills %d" % [level, kills]