tool
extends StaticBody2D

export(int, "Left", "Right") var dir
export(int, "Car", "Police car", "Playercar") var type

func _ready():
	get_child(type).show()
	
	if dir == 0:
		$Spr.region_rect = Rect2(2, 1, 86, 43)
		$Spr2.region_rect = Rect2(2, 1, 86, 43)
		$Spr3.region_rect = Rect2(2, 1, 86, 43)
	elif dir == 1:
		$Spr.region_rect = Rect2(2, 121, 87, 43)
		$Spr2.region_rect = Rect2(2, 121, 87, 43)
		$Spr3.region_rect = Rect2(2, 1, 86, 43)
