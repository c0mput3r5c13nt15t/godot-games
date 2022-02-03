extends KinematicBody2D

export (NodePath) var Guard_Coordination = '../Guard_Coordination'

export(int, "Sniper", "Policeman") var type

export (int) var speed = 200
export (int) var health = 100
export (int) var reaction_time = 0.5

export (int) var arrest_time = 3
export (int) var shooting_range = 450

var player = null
var others = []

var path : = PoolVector2Array() setget set_path
var standard_path = PoolVector2Array()
var pos_on_path = 0
var waiting = false
var reacting = false

export var looking_around = true
export var looking_speed = 0
export var looking_speed_range = 0.5

func _ready():
	speed += int(rand_range(-5, 5))

	looking_around = true
	looking_speed = rand_range(-looking_speed_range, looking_speed_range)

	set_physics_process(false)

	if type != 0:
		$Gun.queue_free()
	else:
		speed /= 2

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
	if looking_around:
		$View.rotation_degrees += looking_speed

	if player:
		if not player.tarned:
			$View.rotation = get_angle_to(player.global_position)
			looking_around = false

		if get_node(Guard_Coordination).danger:
			looking_around = false
			if type == 0:
				if global_position.distance_to(player.global_position) < shooting_range:
					if path.size() > 0:
						set_physics_process(false)

					if not $Gun.reloading:
						shoot()
				else:
					set_path(get_node(Guard_Coordination).get_nav_path(position, player.global_position))
			if type == 1:
				set_path(get_node(Guard_Coordination).get_nav_path(position, player.global_position))
		else:
			if player.gun == true and not player.tarned and not reacting:
				$Reaction.start(reaction_time)
				reacting = true
			elif standard_path and not waiting:
				set_path(get_node(Guard_Coordination).get_nav_path(position, standard_path[pos_on_path]))
				if pos_on_path+1 == len(standard_path):
					pos_on_path = 0
				else:
					pos_on_path += 1
				waiting = true
				$Wait.start(5)
	elif get_node(Guard_Coordination).danger:
		player = get_node(get_node(Guard_Coordination).Player)

		if type == 0 and global_position.distance_to(player.global_position) >= shooting_range:
			set_path(get_node(Guard_Coordination).get_nav_path(position, player.global_position))
		elif type == 1:
			set_path(get_node(Guard_Coordination).get_nav_path(position, player.global_position))
	elif standard_path and not waiting:
		set_path(get_node(Guard_Coordination).get_nav_path(position, standard_path[pos_on_path]))
		if pos_on_path+1 == len(standard_path):
			pos_on_path = 0
		else:
			pos_on_path += 1
		waiting = true
		$Wait.start(15)

	if others:
		for other in others:
			if other.health <= 0 and not reacting:
				set_path(get_node(Guard_Coordination).get_nav_path(position, other.global_position+Vector2(int(rand_range(-32, 32)), int(rand_range(-32, 32)))))
				$Reaction.start(reaction_time)
				reacting = true

func shoot():
	$Gun.shoot()

func arrest():
	if player:
		player.arrest()

func strangle():
	health = 0
	$Strangled.play(0.0)

	if player:
		get_node(Guard_Coordination).danger = true

	if (health <= 0):
		dead()

func _on_Hurt_area_entered(area):
	if not area.get('damage') == null and not area.get('shooter') == self:
		health -= area.damage

		if (health <= 0):
			dead(true)

func _on_View_body_entered(body):
	if body.is_in_group('Player'):
		player = body
	elif not body.get('health') == null:
		others.append(body)

func _on_View_body_exited(body):
	if body == player:
		player = null
		if health > 0:
			looking_around = true
	elif body in others:
		others.erase(body)

func _on_Arrest_area_entered(area):
	if area.get_parent().is_in_group('Player') and get_node(Guard_Coordination).danger:
		$Arrest2.start(arrest_time)

func _on_Arrest_area_exited(area):
	if area.get_parent().is_in_group('Player'):
		$Arrest2.stop()

func _on_Arrest2_timeout():
	arrest()

func dead(blood=false):
	#$Col.disabled = true
	$Dead.show()
	$Spr.hide()

	$Hurt.queue_free()

	set_process(false)
	set_physics_process(false)

	$View/Pol.hide()
	looking_around = false
	
	if type == 0 and get_node_or_null('Gun') != null:
		$Gun.queue_free()
	else:
		$Arrest2.stop()

	if blood:
		$Blood.emitting = true

func _on_Wait_timeout():
	waiting = false

func _on_Reaction_timeout():
	get_node(Guard_Coordination).danger = true
	get_node(Guard_Coordination).panic = true
	# set_path(get_node(Guard_Coordination).get_nav_path(position, player.global_position))
