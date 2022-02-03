extends RigidBody2D

var health = Values.UNGUIDED_EXPLOSIVES["basic"]["health"]

var damage = Values.UNGUIDED_EXPLOSIVES["basic"]["damage"]
var damage_type = Values.UNGUIDED_EXPLOSIVES["basic"]["damage_type"]
var lifetime = Values.UNGUIDED_EXPLOSIVES["basic"]["lifetime"]

var linear_acceleration = Vector2()

var group = ''

func _ready():
	add_to_group(Values.UNGUIDED_EXPLOSIVES["type"])
	mass = Values.UNGUIDED_EXPLOSIVES["basic"]["mass"]

func init(parent_velocity, inaccuracy=1, set_group=0, _set_target=null):
	linear_velocity += parent_velocity
	add_to_group(str(set_group))
	group = str(set_group)

	global_rotation_degrees += rand_range(-inaccuracy, inaccuracy)

	$lifetimer.start(lifetime)

func _physics_process(delta):
	if health <= 0:
		queue_free()

	linear_acceleration = Vector2(0, -$thruster.force / mass).rotated($thruster.global_rotation)
	linear_velocity += linear_acceleration * delta

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
	print('Hit')

func _on_hit_body_entered(body):
	var hit = body.deal_damage(group)
	if hit:
		health -= hit[0]
		body.queue_free()
	print('Hit')
