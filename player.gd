extends CharacterBody2D

func _physics_process(_delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * 200
	move_and_slide()

func _on_weapon_area_entered(area):
	if area.is_in_group("Player") and not $Weapon.visible:
		area.queue_free()
		%Weapon.visible = true
