extends Node

class_name PlayerInputComponent

signal input_detected(direction)

func _input(event):
	if event.is_action_pressed("ui_up"):
		var direction: Vector2 = Vector2(0, -1)
		emit_signal("input_detected", direction)
	elif event.is_action_pressed("ui_right"):
		var direction: Vector2 = Vector2(1, 0)
		emit_signal("input_detected", direction)
	elif event.is_action_pressed("ui_down"):
		var direction: Vector2 = Vector2(0, 1)
		emit_signal("input_detected", direction)
	elif event.is_action_pressed("ui_left"):
		var direction: Vector2 = Vector2(-1, 0)
		emit_signal("input_detected", direction)
