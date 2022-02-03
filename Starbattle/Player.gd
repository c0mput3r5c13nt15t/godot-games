extends Node

var STATES = {
	Values.MAIN_WEAPON: Values.AUTO_FIRE,
	Values.SECONDARY_WEAPON: Values.AUTO_FIRE,
	Values.TERTIARY_WEAPON: Values.AUTO_FIRE,
	Values.QUATERNARY_WEAPON: Values.AUTO_FIRE,
	Values.QUINARY_WEAPON: Values.AUTO_FIRE,
	Values.SENARY_WEAPON: Values.AUTO_FIRE,
	Values.SEPTENARY_WEAPON: Values.AUTO_FIRE,
	Values.OCTONARY_WEAPON: Values.AUTO_FIRE,
	Values.NONARY_WEAPON: Values.AUTO_FIRE,
	Values.OTHER_WEAPON: Values.AUTO_FIRE,
}

func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_1:
		STATES[Values.MAIN_WEAPON] = toogle(STATES[Values.MAIN_WEAPON])
	elif event is InputEventKey and event.pressed and event.scancode == KEY_2:
		STATES[Values.SECONDARY_WEAPON] = toogle(STATES[Values.SECONDARY_WEAPON])
	elif event is InputEventKey and event.pressed and event.scancode == KEY_3:
		STATES[Values.TERTIARY_WEAPON] = toogle(STATES[Values.TERTIARY_WEAPON])
	elif event is InputEventKey and event.pressed and event.scancode == KEY_4:
		STATES[Values.QUATERNARY_WEAPON] = toogle(STATES[Values.QUATERNARY_WEAPON])
	elif event is InputEventKey and event.pressed and event.scancode == KEY_5:
		STATES[Values.QUINARY_WEAPON] = toogle(STATES[Values.QUINARY_WEAPON])
	elif event is InputEventKey and event.pressed and event.scancode == KEY_6:
		STATES[Values.SENARY_WEAPON] = toogle(STATES[Values.SENARY_WEAPON])
	elif event is InputEventKey and event.pressed and event.scancode == KEY_7:
		STATES[Values.SEPTENARY_WEAPON] = toogle(STATES[Values.SEPTENARY_WEAPON])
	elif event is InputEventKey and event.pressed and event.scancode == KEY_8:
		STATES[Values.OCTONARY_WEAPON] = toogle(STATES[Values.OCTONARY_WEAPON])
	elif event is InputEventKey and event.pressed and event.scancode == KEY_9:
		STATES[Values.NONARY_WEAPON] = toogle(STATES[Values.NONARY_WEAPON])
	elif event is InputEventKey and event.pressed and event.scancode == KEY_0:
		STATES[Values.OTHER_WEAPON] = toogle(STATES[Values.OTHER_WEAPON])

func toogle(current_state):
	if current_state < 3:
		return current_state + 1
	else:
		return 0
