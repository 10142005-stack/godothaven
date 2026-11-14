extends Control

var xp = 0
var xp_max = 100

func _process(delta):
	$XPLabel.text = "XP: %d/%d" % [xp, xp_max]

func add_xp(amount):
	xp += amount
	if xp > xp_max:
		xp = xp_max
