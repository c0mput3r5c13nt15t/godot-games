extends Node2D

var force = 0
export(int, "forward", "backward", "strave_left", "strave_right", "rotate_left", "rotate_right") var direction
export var factor = 1.0

func _ready():
	if direction <=3:
		force = Values.THRUSTERS["ion"]["main_force"] * factor
	else:
		force = Values.THRUSTERS["ion"]["steer_force"] * factor

func thrust():
	$anim.play("thrust")
