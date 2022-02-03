extends Node2D

onready var bullet = preload("res://Szenen/Bullet.tscn")

# warning-ignore:unused_class_variable
export var rot_speed = deg2rad(5)
export (int) var bullet_speed = 300
export (int) var bullet_dmg = 10
export (int) var reloading_time = 1
export(int, "Player", "Enemy") var parent

var reloading = false

func get_rot():
	if parent == 0:
		return get_angle_to(get_global_mouse_position())
	elif parent == 1 and get_parent().player:
		return get_angle_to(get_parent().player.global_position)
	else:
		return get_angle_to(Vector2(1, 0))

# warning-ignore:unused_argument
func _physics_process(delta):
	rotation += get_rot()
	if rotation_degrees > 360:
		rotation_degrees -= 360
	elif rotation_degrees < 0:
		rotation_degrees = 360 - rotation_degrees

	if rotation_degrees >90 and rotation_degrees < 270:
		$Spr.flip_v = true
	else:
		$Spr.flip_v = false

func shoot():
	if reloading == false:
		var b = bullet.instance()
		b.shoot($Pos.global_position, Vector2(1, 0).rotated(rotation), rotation_degrees, bullet_speed, bullet_dmg, get_parent())
		get_parent().get_parent().get_parent().get_child(3).add_child(b)
		$Shot.play(0.0)
		reloading = true
		$Reloading.start(reloading_time)

func _on_Reloading_timeout():
	reloading = false
