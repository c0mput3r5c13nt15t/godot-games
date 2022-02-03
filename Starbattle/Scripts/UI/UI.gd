extends CanvasLayer

onready var weapon = preload("res://Scenes/UI/Weapon.tscn")

func _ready():
	for state in Player.STATES:
		var w = weapon.instance()
		w.role = state
		$toolbar/weapons.add_child(w)
