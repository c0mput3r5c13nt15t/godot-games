extends Navigation2D

onready var target = preload("res://Szenen/Target.tscn")
onready var enemy = preload("res://Szenen/Enemy.tscn")
onready var person = preload("res://Szenen/Person.tscn")
onready var tree = preload("res://Szenen/Tree.tscn")
onready var fence = preload("res://Szenen/Fence.tscn")
onready var car = preload("res://Szenen/Car.tscn")

export (NodePath) var MobsPath = "../../Mobs"

var Mobs = null
var start_pos = Vector2()
var fleeing_point = Vector2()

enum objects {Nothing, Player, Target, Policeofficer, Sniper, Person, Car, Police_car, Tree, Fence}
enum use_cases {Position, Line}

func _ready():
	start_pos = $Positions/Player.global_position
	fleeing_point = $FleeingPoint.global_position

	Mobs = get_node(MobsPath)

	hide()

func init():
	show()
	$NavShape.enabled = true
	$Walls.set_collision_layer_bit(1, true)
	$Walls/Doors.set_collision_layer_bit(1, true)

	for area in $Areas.get_children():
		area.monitorable = true

	for position in $Positions.get_children():
		if not "Object" in position.name:
			pass
		elif position.type == objects.Target:
			var t = target.instance()
			
			if position.use_case == use_cases.Line:
				t.position = position.points[0]
				t.standard_path = position.points
			else:
				t.position = position.global_position

			t.fleeing_point = fleeing_point
			Mobs.add_child(t)
		elif position.type == objects.Policeofficer:
			var e = enemy.instance()
			e.type = 1

			if position.use_case == use_cases.Line:
				e.position = position.points[0]
				e.standard_path = position.points
			else:
				e.position = position.global_position

			Mobs.add_child(e)
		elif position.type == objects.Sniper:
			var e = enemy.instance()
			e.type = 0

			if position.use_case == use_cases.Line:
				e.position = position.points[0]
				e.standard_path = position.points
			else:
				e.position = position.global_position

			Mobs.add_child(e)
		elif position.type == objects.Person:
			var p = person.instance()
			p.position = position.global_position
			p.fleeing_point = fleeing_point
			Mobs.add_child(p)
		elif position.type == objects.Fence:
			var f = fence.instance()
			f.position = position.global_position
			Mobs.add_child(f)
		elif position.type == objects.Tree:
			var t = tree.instance()
			t.position = position.global_position
			Mobs.add_child(t)
		elif position.type == objects.Car:
			var c = car.instance()
			c.position = position.global_position
			Mobs.add_child(c)
		elif position.type == objects.Police_car:
			var c = car.instance()
			c.position = position.global_position
			c.type = 1
			Mobs.add_child(c)

func reset():
	hide()

	# $NavShape.enabled = false
	$Walls.set_collision_layer_bit(1, false)
	$Walls/Doors.set_collision_layer_bit(1, false)

	for area in $Areas.get_children():
		area.monitorable = false
