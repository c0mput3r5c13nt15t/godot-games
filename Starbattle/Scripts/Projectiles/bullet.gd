extends Area2D

var velocity = Vector2(0, -1)
var parent_velocity = Vector2()
var speed = Values.PROJECTILES["basic"]["speed"]

var damage = Values.PROJECTILES["basic"]["damage"]
var damage_type = Values.PROJECTILES["basic"]["damage_type"]
var lifetime = Values.PROJECTILES["basic"]["lifetime"]

var group = ''

func _ready():
	add_to_group(Values.PROJECTILES["type"])

func init(set_parent_velocity, inaccuracy=0, set_group=0):
	add_to_group(str(set_group))
	group = str(set_group)

	parent_velocity = set_parent_velocity

	rotation_degrees += rand_range(-inaccuracy, inaccuracy)

	$lifetimer.start(lifetime)

func _physics_process(delta):
	global_position += (velocity.rotated(rotation) * speed  + parent_velocity) * delta

func deal_damage(target_group):
	if not str(target_group) == group:
		return [damage, damage_type]
	else:
		return false

func _on_lifetimer_timeout():
	queue_free()
