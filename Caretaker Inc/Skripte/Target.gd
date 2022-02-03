extends KinematicBody2D

export (NodePath) var Guard_Coordination = '../Guard_Coordination'

export (int) var health = 100
export (int) var speed = 90
var fleeing = false
var fleeing_point = Vector2()

var path : = PoolVector2Array() setget set_path
var standard_path = PoolVector2Array()
var pos_on_path = 0
var waiting = false

func _ready():
	speed += int(rand_range(-10, 10))

func set_path(value):
	path = value
	if value.size() == 0:
		return
	set_physics_process(true)

func move_along_path(distance):
	var start_point = position
# warning-ignore:unused_variable
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance/distance_to_next)
			break
		elif distance <= 0.0:
			position = path[0]
			set_physics_process(false)
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

func _physics_process(delta):
	var move_distance = speed * delta
	move_along_path(move_distance)

# warning-ignore:unused_argument
func _process(delta):
	if get_node(Guard_Coordination).panic and not fleeing:
		set_path(get_node(Guard_Coordination).get_nav_path(position, fleeing_point))
		fleeing = true
	elif standard_path and not waiting and not fleeing:
		set_path(get_node(Guard_Coordination).get_nav_path(position, standard_path[pos_on_path]))
		if pos_on_path+1 == len(standard_path):
			pos_on_path = 0
		else:
			pos_on_path += 1
		waiting = true
		$Wait.start(15)

func _on_Hurt_area_entered(area):
	if not area.get('damage') == null:
		health -= area.damage

	if (health <= 0):
		dead(true)

func strangle():
	health = 0
	$Strangled.play(0.0)

	if (health <= 0):
		dead()

func dead(blood=false):
	$Dead.show()
	$Spr.hide()

	$Hurt.queue_free()

	set_process(false)
	set_physics_process(false)

	if blood:
		$Blood.emitting = true

	get_node(Guard_Coordination).target_killed()

# warning-ignore:unused_argument
func _on_Flee_area_entered(area):
	queue_free()

func _on_Wait_timeout():
	waiting = false
