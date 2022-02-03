extends Node2D

class_name Snake

signal move_triggered(entity, direction)
signal generated_tail_segment(segment, segment_position)
signal body_segment_move_triggered(segment, segment_position)
signal size_changed(length)

# Declare member variables here. Examples:
onready var direction: Vector2 = Vector2()
onready var can_move: bool = false
onready var body_segments: Array = [self]

const scene_tail = preload("res://entities/tail/Tail.tscn")

onready var moved_fields: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerInputComponent.connect("input_detected", self, "_on_PlayerInputComponent_input_detected")
	emit_signal("size_changed", body_segments.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if direction != Vector2() and can_move:
		var old_position_of_segment_in_front: Vector2 = self.position
		emit_signal("move_triggered", self, direction)
		if body_segments.size() > 1:
			for i in range(1, body_segments.size()):
				var temp_pos: Vector2 = body_segments[i].position
				emit_signal("body_segment_move_triggered", body_segments[i], old_position_of_segment_in_front)
				old_position_of_segment_in_front = temp_pos
		
		moved_fields = moved_fields + 1
		can_move = false
		$MoveDelay.start()


func _on_PlayerInputComponent_input_detected(new_direction) -> void:
	if new_direction != direction * -1 and moved_fields != 0:
		direction = new_direction
		moved_fields = 0

func _on_MoveDelay_timeout() -> void:
	can_move = true

func eat_food(value) -> void:
	for i in range(value):
		var tail_segment: Node2D = scene_tail.instance() as Node2D
		body_segments.append(tail_segment)

		emit_signal("generated_tail_segment", tail_segment, body_segments[-2].position)
		emit_signal("size_changed", body_segments.size())
