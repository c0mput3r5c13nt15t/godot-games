extends Control

var role = ""

func _process(_delta):
	if Player.STATES[role] == Values.AUTO_FIRE:
		$TextureRect/ColorRect.color = Color("00ff00")
	elif Player.STATES[role] == Values.PLAYER_CONTROLL:
		$TextureRect/ColorRect.color = Color("0000ff")
	elif Player.STATES[role] == Values.CONTINOUS_FIRE:
		$TextureRect/ColorRect.color = Color("ff9900")
	elif Player.STATES[role] == Values.NO_FIRE:
		$TextureRect/ColorRect.color = Color("ff0000")
	else:
		$TextureRect/ColorRect.color = Color("ffffff")
