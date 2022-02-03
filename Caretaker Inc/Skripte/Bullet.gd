extends Area2D

var velocity = Vector2()
var speed = 0
var damage = 0
var shooter = null

func shoot(pos, vel, rot, spe, dam, sho=null, lifetime=3.0):
	global_position = pos
	velocity = vel
	speed = spe
	damage = dam
	self.shooter = sho
	rotation_degrees += rot

	$Lifetime.wait_time = lifetime

	set_physics_process(true)

func _physics_process(delta):
	global_position += velocity * speed * delta

func _on_Bullet_area_entered(area):
	if is_instance_valid(shooter):
		if not shooter.is_a_parent_of(area):
			queue_free()
	else:
		queue_free()

func _on_Lifetime_timeout():
	queue_free()
