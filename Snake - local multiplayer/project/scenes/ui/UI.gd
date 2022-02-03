extends CanvasLayer

func update_score(length, player_id):
	if player_id == 0:
		$"Control/Score 1".text = "Player 1: " + str(length*100)
	elif player_id == 1:
		$"Control/Score 2".text = "Player 2: " + str(length*100)

func _ready():
	$Credits.hide()
	$Start.show()
	$Control.show()
	$"Control/Score 1".text = "Player 1: " + str(100)
	$"Control/Score 2".text = "Player 2: " + str(100)

func _process(_delta):
	if Input.is_action_just_released("ui_accept") and $Start.visible:
		$Start.hide()
		get_tree().paused = false
		$Music.start()
	if get_tree().paused and $Music.playing:
		$Music.stop()

	if Input.is_action_pressed("ui_credits") and get_tree().paused and $Start.visible and not $Credits.visible:
		$Credits.show()
	elif Input.is_action_pressed("ui_escape") and get_tree().paused and $Start.visible and $Credits.visible:
		$Credits.hide()
