extends Control

export(NodePath) var spaceship_path = null

var spaceship = null

func _ready():
	if is_inside_tree():
		spaceship = get_node(spaceship_path)
		$"health bar".max_value = spaceship.max_health

func _process(_delta):
	if spaceship:
		$"health bar".value = spaceship.health
