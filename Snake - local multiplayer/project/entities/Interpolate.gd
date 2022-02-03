extends Sprite

export(NodePath) var follow = ""
const FOLLOW_SPEED = 15.0

func _physics_process(delta):
	if get_node_or_null(follow) != null:
		var follow_pos = get_node(follow).global_position
		global_position = lerp(global_position, follow_pos, 0.4)
		# global_position = global_position.linear_interpolate(follow_pos, delta * FOLLOW_SPEED)
	else:
		queue_free()
