tool

extends Line2D

export (int, "Nothing", "Player", "Target", "Policeofficer", "Sniper", "Person",
			 "Car", "Police car", "Tree", "Fence") var type setget set_sprite

export (int, "Position", "Path") var use_case

func _ready():
	if Engine.editor_hint:
		set_sprite(type)
	else:
		hide()
		hide_all()

func set_sprite(new_type):
	hide_all()
	if new_type < get_child_count():
		get_child(new_type).show()
	type = new_type

func hide_all():
	for child in get_children():
		child.hide()
