extends Line2D

onready var target = get_parent()

export var trail_lenght = 100

var point

func _physics_process(_delta):
	global_position = Vector2(0, 0)
	global_rotation = 0
	point = target.position
	add_point(point)
	
	while get_point_count() > trail_lenght:
		remove_point(0)
