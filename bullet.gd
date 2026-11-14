extends Area2D

var direction := Vector2.RIGHT
var speed := 520.0
var damage := 1
var _life := 2.0


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	_life -= delta
	if _life <= 0.0:
		queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()