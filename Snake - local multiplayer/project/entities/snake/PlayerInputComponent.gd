extends Node

export(int, "Player 1", "Player 2") var player

class_name PlayerInputComponent

signal input_detected(direction)

func _input(event):
	if player == 0:
		if event.is_action_pressed("p1-up"):
			var direction: Vector2 = Vector2(0, -1)
			emit_signal("input_detected", direction)
		elif event.is_action_pressed("p1-right"):
			var direction: Vector2 = Vector2(1, 0)
			emit_signal("input_detected", direction)
		elif event.is_action_pressed("p1-down"):
			var direction: Vector2 = Vector2(0, 1)
			emit_signal("input_detected", direction)
		elif event.is_action_pressed("p1-left"):
			var direction: Vector2 = Vector2(-1, 0)
			emit_signal("input_detected", direction)
	else:
		if event.is_action_pressed("p2-up"):
			var direction: Vector2 = Vector2(0, -1)
			emit_signal("input_detected", direction)
		elif event.is_action_pressed("p2-right"):
			var direction: Vector2 = Vector2(1, 0)
			emit_signal("input_detected", direction)
		elif event.is_action_pressed("p2-down"):
			var direction: Vector2 = Vector2(0, 1)
			emit_signal("input_detected", direction)
		elif event.is_action_pressed("p2-left"):
			var direction: Vector2 = Vector2(-1, 0)
			emit_signal("input_detected", direction)
