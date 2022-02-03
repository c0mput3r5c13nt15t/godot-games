extends Node2D

export (NodePath) var GUI

var mission_complete = false
var level = 1
var max_level = 2

var dialogs = [["Hello, 47. Today you'll be taking care of Juan Pablo Ledesma.", "He has been traveling for 10 hours and is taking a little break.", "Try to eliminate his guards silently or he might flee."],
				["Good Job with Juan! Your next target is Servando Gómez Martínez. His is taking a little break and looks very exhausted, so take care of him."]]

func _ready():
	pass

func reset():
	mission_complete = false
	$Mobs/Guard_Coordination.reset()

	for iterate_level in range(max_level):
		$Levels.get_child(iterate_level).reset()

	for mob in $Mobs.get_children():
		if not mob.name == 'Player' and not mob.name == 'Guard_Coordination':
			mob.queue_free()

	for bullet in $Bullets.get_children():
		bullet.queue_free()

	level = 1
	load_level()

func load_level():
	if level == 1:
		get_node(GUI).tutorial()

	mission_complete = false

	$Levels.get_child(level-1).init()
	$Mobs/Guard_Coordination.Nav = $Levels.get_child(level-1).get_path()
	$Mobs/Guard_Coordination.reset()
	$Mobs/Player.global_position = $Levels.get_child(level-1).start_pos
	$Mobs/Player.reset()
	get_node(GUI).dialog(dialogs[level-1])

func next_level():
	mission_complete = false
	$Mobs/Guard_Coordination.reset()

	$Levels.get_child(level-1).reset()

	for mob in $Mobs.get_children():
		if not mob.name == 'Player' and not mob.name == 'Guard_Coordination':
			mob.queue_free()

	for bullet in $Bullets.get_children():
		bullet.queue_free()

	if level  >= max_level:
		get_node(GUI).finished()
		level = 1
	else:
		level += 1
		load_level()

func retry():
	mission_complete = false
	$Mobs/Guard_Coordination.reset()

	$Levels.get_child(level-1).reset()

	for mob in $Mobs.get_children():
		if not mob.name == 'Player' and not mob.name == 'Guard_Coordination':
			mob.queue_free()

	for bullet in $Bullets.get_children():
		bullet.queue_free()

	load_level()

func target_killed():
	mission_complete = true

func leave():
	if mission_complete == true:
		win('You successfully took care of our little friend...')
	else:
		lose('You did not take care of him')

func leave_ui():
	get_node(GUI).leave()

func win(text=''):
	get_node(GUI).win(text)

func lose(text=''):
	get_node(GUI).lose(text)
