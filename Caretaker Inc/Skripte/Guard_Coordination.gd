extends Node2D

export (NodePath) var Nav
export (NodePath) var Main
# warning-ignore:unused_class_variable
export (NodePath) var Player

var danger = false
var panic = false

func _ready():
	pass

func reset():
	danger = false
	panic = false

func action():
	danger = true
	panic = true
	print("action")

func target_killed():
	get_node(Main).target_killed()

func get_nav_path(start, end):
	return get_node(Nav).get_simple_path(start, end)
