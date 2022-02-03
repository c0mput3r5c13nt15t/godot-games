extends Node2D

onready var projectile = preload("res://Scenes/Projectiles/bullet.tscn")

onready var range_collison_shape = $range/range_shape
onready var view_range_collison_shape = $view/range_shape
onready var muzzle_positions = $muzzle_positions
onready var bullet_container = get_tree().get_nodes_in_group("bullet_container")[0]
onready var spaceship = get_parent().get_parent()

var rotation_speed = Values.TURRETS["basic"]["rotation_speed"]
var range_size = Values.TURRETS["basic"]["range"]
var view_range_size = Values.TURRETS["basic"]["view_range"]
var inaccuracy = Values.TURRETS["basic"]["inaccuracy"]
var reload_time = Values.TURRETS["basic"]["reload_time"]
var magazine_size = Values.TURRETS["basic"]["magazine_size"]
var magazine_reload_time = Values.TURRETS["basic"]["magazine_reload_time"]
var preferred_target_types = Values.TURRETS["basic"]["preferred_targets"]
var other_target_types = Values.TURRETS["basic"]["other_targets"]

var reloading = false
var reloading_magazine = false
var ammunition_in_magazine = magazine_size

export(int, "mw", "2w", "3w", "4w", "5w", "6w", "7w", "8w", "9w", "ow") var role = 9
var preferred_targets = []
var other_targets = []
var preferred_targets_in_view = []
var other_targets_in_view = []

func _ready():
	add_to_group(Values.TURRETS["type"])

	var range_shape = CircleShape2D.new()
	range_shape.radius = range_size
	range_collison_shape.shape = range_shape

	var view_range_shape = CircleShape2D.new()
	view_range_shape.radius = view_range_size
	view_range_collison_shape.shape = view_range_shape

func _physics_process(delta):
	var target = null

	if preferred_targets:
		target = preferred_targets[0]
	elif other_targets:
		target = other_targets[0]
	elif preferred_targets_in_view:
		target = preferred_targets_in_view[0]
	elif other_targets_in_view:
		target = other_targets_in_view[0]

	if ammunition_in_magazine <= 0 and not reloading_magazine:
		reloading_magazine = true
		$reload_magazine.start(magazine_reload_time)

	if spaceship.player_controlled and (Player.STATES[role] == Values.PLAYER_CONTROLL or Player.STATES[role] == Values.CONTINOUS_FIRE):
		var vector_towards_mouse = get_global_mouse_position() - self.global_position
		var angle = (atan2(vector_towards_mouse.y, vector_towards_mouse.x) + 0.5 * PI)
		global_rotation = Global.lerp_angle(global_rotation, angle, delta * rotation_speed)
		
		if (Input.is_action_pressed("Shoot") or Player.STATES[role] == Values.CONTINOUS_FIRE) and not reloading and not reloading_magazine:
			shoot()
	elif target and (not spaceship.player_controlled or Player.STATES[role] != Values.NO_FIRE):
		var distance_now = global_position.distance_to(target.global_position)
		
		var eti = distance_now / Values.PROJECTILES["basic"]["speed"]
		
		var future_target_position = Vector2()
		print(-target.linear_acceleration / target.mass)
		future_target_position = target.global_position + target.linear_velocity * eti + 0.5 * -target.linear_acceleration / target.mass * eti * eti
		print(future_target_position)
			
		#if distance_now > global_position.distance_to(future_target_position):
		#	future_target_position += target.linear_velocity
		#elif distance_now < global_position.distance_to(future_target_position):
	#		future_target_position -= target.linear_velocity

		var vector_towards_future_target = (future_target_position) - self.global_position
		var future_angle = atan2(vector_towards_future_target.y, vector_towards_future_target.x) + 0.5 * PI
		
		var vector_towards_target = (target.global_position) - self.global_position
		var angle = atan2(vector_towards_target.y, vector_towards_target.x) + 0.5 * PI

		if int(abs(rad2deg(Global.short_angle_dist(angle, future_angle)))) > 100:
			global_rotation = Global.lerp_angle(global_rotation, angle, delta * rotation_speed)
		else:
			global_rotation = Global.lerp_angle(global_rotation, future_angle, delta * rotation_speed)
		
		if not reloading and not reloading_magazine and (global_position.distance_to(target.global_position) < range_size or Player.STATES[role] == Values.CONTINOUS_FIRE):
			shoot()

func shoot():
	for muzzle_pos in muzzle_positions.get_children():
		var new_projectile = projectile.instance()
		new_projectile.global_position = muzzle_pos.global_position
		new_projectile.global_rotation = global_rotation
		bullet_container.add_child(new_projectile)
		new_projectile.init(spaceship.linear_velocity, inaccuracy, str(spaceship.group))

		ammunition_in_magazine -= 1

	reloading = true
	$reload.start(reload_time)

func _on_reload_timeout():
	reloading = false

func _on_reload_magazine_timeout():
	ammunition_in_magazine = magazine_size
	reloading_magazine = false

func _on_range_area_entered(area):
	var parent = area.get_parent()

	if parent:
		for parent_type in parent.get_groups():
			if parent_type in preferred_target_types:
				preferred_targets.append(parent)
				break
			elif parent_type in other_target_types:
				other_targets.append(parent)
				break

func _on_range_area_exited(area):
	var parent = area.get_parent()
	if parent:
		if parent in preferred_targets:
			preferred_targets.erase(parent)
	
		if parent in other_targets:
			other_targets.erase(parent)

func _on_range_body_entered(body):
	if not body.is_in_group(str(get_parent().get_parent().group)):
		for body_type in body.get_groups():
			if body_type in preferred_target_types:
				preferred_targets.append(body)
				break
			elif body_type in other_target_types:
				other_targets.append(body)
				break

func _on_range_body_exited(body):
	if body in preferred_targets:
		preferred_targets.erase(body)

	if body in other_targets:
		other_targets.erase(body)

func _on_view_area_entered(area):
	var parent = area.get_parent()

	if parent:
		for parent_type in parent.get_groups():
			if parent_type in preferred_target_types:
				preferred_targets_in_view.append(parent)
				break
			elif parent_type in other_target_types:
				other_targets_in_view.append(parent)
				break

func _on_view_area_exited(area):
	var parent = area.get_parent()
	if parent:
		if parent in preferred_targets_in_view:
			preferred_targets_in_view.erase(parent)
	
		if parent in other_targets_in_view:
			other_targets_in_view.erase(parent)

func _on_view_body_entered(body):
	if not body.is_in_group(str(get_parent().get_parent().group)):
		for body_type in body.get_groups():
			if body_type in preferred_target_types:
				preferred_targets_in_view.append(body)
				break
			elif body_type in other_target_types:
				other_targets_in_view.append(body)
				break

func _on_view_body_exited(body):
	if body in preferred_targets_in_view:
		preferred_targets_in_view.erase(body)

	if body in other_targets_in_view:
		other_targets_in_view.erase(body)
