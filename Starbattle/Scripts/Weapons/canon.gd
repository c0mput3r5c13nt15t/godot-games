extends Node2D

onready var projectile = preload("res://Scenes/Projectiles/bullet.tscn")

onready var range_collison_shape = $range/range_shape
onready var muzzle_positions = $muzzle_positions
onready var bullet_container = get_tree().get_nodes_in_group("bullet_container")[0]
onready var spaceship = get_parent().get_parent()

var range_size = Values.CANONS["basic"]["range"]
var inaccuracy = Values.CANONS["basic"]["inaccuracy"]
var reload_time = Values.CANONS["basic"]["reload_time"]
var magazine_size = Values.CANONS["basic"]["magazine_size"]
var magazine_reload_time = Values.CANONS["basic"]["magazine_reload_time"]
var preferred_target_types = Values.CANONS["basic"]["preferred_targets"]
var other_target_types = Values.CANONS["basic"]["other_targets"]

var reloading = false
var reloading_magazine = false
var ammunition_in_magazine = magazine_size

export(int, "mw", "2w", "3w", "4w", "5w", "6w", "7w", "8w", "9w", "ow") var role = 0
var preferred_targets = []
var other_targets = []

func _ready():
	add_to_group(Values.CANONS["type"])

	# TODO dynamic range!

func _physics_process(_delta):
	var target = null

	if preferred_targets:
		target = preferred_targets[0]
	elif other_targets:
		target = other_targets[0]

	if ammunition_in_magazine <= 0 and not reloading_magazine:
		reloading_magazine = true
		$reload_magazine.start(magazine_reload_time)

	if spaceship.player_controlled and (Player.STATES[role] == Values.PLAYER_CONTROLL or Player.STATES[role] == Values.CONTINOUS_FIRE):
		if (Input.is_action_pressed("Shoot") or Player.STATES[role] == Values.CONTINOUS_FIRE) and not reloading and not reloading_magazine:
			shoot()
	elif target and (not spaceship.player_controlled or Player.STATES[role] != Values.NO_FIRE):
		if not reloading and not reloading_magazine:
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

func _on_reload_timeout():
	reloading = false

func _on_reload_magazine_timeout():
	ammunition_in_magazine = magazine_size
	reloading_magazine = false
