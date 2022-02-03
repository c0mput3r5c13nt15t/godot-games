extends RigidBody2D

var target = null
var target_position = Vector2()
var rotation_speed = Values.GUIDED_EXPLOSIVES["basic"]["rotation_speed"]

var health = Values.GUIDED_EXPLOSIVES["basic"]["health"]

var damage = Values.GUIDED_EXPLOSIVES["basic"]["damage"]
var damage_type = Values.GUIDED_EXPLOSIVES["basic"]["damage_type"]
var lifetime = Values.GUIDED_EXPLOSIVES["basic"]["lifetime"]

var group = ''

var linear_acceleration = Vector2()
var steering = true

func _ready():
	if target:
		target_position = target.global_position

	var eti = global_position.distance_to(target_position) / -$thruster.force / mass * 3
	$steer.start(eti)
	
	add_to_group(Values.GUIDED_EXPLOSIVES["type"])
	mass = Values.GUIDED_EXPLOSIVES["basic"]["mass"]

func init(parent_velocity, inaccuracy=1, set_group=0, set_target=null):
	linear_velocity += parent_velocity
	add_to_group(str(set_group))
	group = str(set_group)

	if typeof(set_target) == 5:
		target_position = set_target
	else:
		target_position = set_target.global_position
		target = set_target

	rotation_degrees += rand_range(-inaccuracy, inaccuracy)

	$lifetimer.start(lifetime)

func _physics_process(delta):
	if health <= 0:
		queue_free()

	linear_acceleration = Vector2(0, -$thruster.force / mass).rotated($thruster.global_rotation)
	linear_velocity += linear_acceleration * delta
	
	if steering:
		rotation += seek()

func seek():
	var steer = 0
	if target:
		target_position = target.global_position

	if target_position:
		steer = get_angle_to(target_position) + 0.5 * PI
	elif target_position != Vector2():
		steer = get_angle_to(target_position) + 0.5 * PI

	return clamp(steer, -deg2rad(rotation_speed), deg2rad(rotation_speed))

func deal_damage(target_group):
	if not str(target_group) == group:
		return [damage, damage_type]
	else:
		return false

func _on_lifetimer_timeout():
	queue_free()

func _on_hit_area_entered(area):
	var hit = area.deal_damage(group)
	if hit:
		health -= hit[0]
		area.queue_free()

func _on_hit_body_entered(body):
	var hit = body.deal_damage(group)
	if hit:
		health -= hit[0]
		body.queue_free()


func _on_steer_timeout():
	steering = false
