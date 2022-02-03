tool
extends StaticBody2D

export(int, "Bottom", "Top") var dir
export(int, "Car", "Police car", "Playercar") var type

func _ready():
	if type != 2:
		$Flee.queue_free()

	get_child(type).show()

	if dir == 0:
		$Spr.region_rect = Rect2(1, 50, 43, 67)
		$Spr2.region_rect = Rect2(1, 50, 43, 67)
		$Spr3.region_rect = Rect2(1, 50, 43, 67)
	elif dir == 1:
		$Spr.region_rect = Rect2(46, 49, 43, 68)
		$Spr2.region_rect = Rect2(46, 49, 43, 68)
		$Spr3.region_rect = Rect2(46, 49, 43, 68)
