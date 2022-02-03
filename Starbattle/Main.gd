extends Node2D

signal interacted(sender, item, amount)

export(Script) var directory
export(int) var amount = 1

func _ready():
	var player = get_tree().get_nodes_in_group("player_flagship")[0]

	var camera = $camera
	remove_child(camera)
	get_tree().get_nodes_in_group("player_flagship")[0].add_child(camera)
	var _succ = connect("interacted", player, "_on_item_interacted")
	
	
	if is_instance_valid(directory):
		var item = directory.new()
		emit_signal("interacted", self, item, amount)
