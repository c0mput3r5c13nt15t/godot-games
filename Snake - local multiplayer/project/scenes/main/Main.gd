extends Node

# Declare member variables here. Examples:
const interpolate = preload("res://entities/Interpolate.tscn")
const scene_food = preload("res://entities/food/Food.tscn")
const scene_snake = preload("res://entities/snake/Snake.tscn")

onready var grid: Grid = get_node("Grid") as Grid

var player1: Node2D
var player2: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

	setup_entities()
	get_tree().paused = true

func setup_entities() -> void:
	player1 = scene_snake.instance() as Node2D
	player1.connect("move_triggered", self, "_on_Snake_move_triggered")
	player1.connect("generated_tail_segment", self, "_on_Snake_generated_tail_segment")
	player1.connect("body_segment_move_triggered", self, "_on_Snake_body_segment_move_triggered")
	player1.connect("size_changed", self, "_on_Snake_size_changed")
	player1.player = 0
	player2 = scene_snake.instance() as Node2D
	player2.connect("move_triggered", self, "_on_Snake_move_triggered")
	player2.connect("generated_tail_segment", self, "_on_Snake_generated_tail_segment")
	player2.connect("body_segment_move_triggered", self, "_on_Snake_body_segment_move_triggered")
	player2.connect("size_changed", self, "_on_Snake_size_changed")
	player2.player = 1
	add_child(player1)
	add_child(player2)
	move_child(player1, 0)
	move_child(player2, 0)
	grid.place_entity_at_random_pos(player1)
	grid.place_entity_at_random_pos(player2)
	setup_food_entity()

func setup_specific_player(player_id) -> void:
	if player_id == 0:
		player1 = scene_snake.instance() as Node2D
		player1.connect("move_triggered", self, "_on_Snake_move_triggered")
		player1.connect("generated_tail_segment", self, "_on_Snake_generated_tail_segment")
		player1.connect("body_segment_move_triggered", self, "_on_Snake_body_segment_move_triggered")
		player1.connect("size_changed", self, "_on_Snake_size_changed")
		player1.player = 0
		add_child(player1)
		move_child(player1, 0)
		grid.place_entity_at_random_pos(player1)
	elif player_id == 1:
		player2 = scene_snake.instance() as Node2D
		player2.connect("move_triggered", self, "_on_Snake_move_triggered")
		player2.connect("generated_tail_segment", self, "_on_Snake_generated_tail_segment")
		player2.connect("body_segment_move_triggered", self, "_on_Snake_body_segment_move_triggered")
		player2.connect("size_changed", self, "_on_Snake_size_changed")
		player2.player = 1
		add_child(player2)
		move_child(player2, 0)
		grid.place_entity_at_random_pos(player2)

func setup_food_entity() -> void:
	var food_instance: Node2D = scene_food.instance() as Node2D
	add_child_below_node(player2, food_instance)
	grid.place_entity_at_random_pos(food_instance)

func _on_Snake_move_triggered(entity: Node2D, direction: Vector2) -> void:
	grid.move_entity_in_direction(entity, direction)

func _on_Grid_moved_into_death(entity: Node2D) -> void:
	if not entity.get("player") == null:
		if entity.player == 0:
			delete_entities_of_group("Player 0")
			setup_specific_player(0)
		elif entity.player == 1:
			delete_entities_of_group("Player 1")
			setup_specific_player(1)

func delete_entities_of_group(name: String) -> void:
	var entities: Array = get_tree().get_nodes_in_group(name)
	for entity in entities:
		entity.queue_free()

func _on_Grid_moved_onto_food(food_entity: Node2D, entity: Node2D) -> void:
	if entity.has_method("eat_food"):
		entity.eat_food(food_entity.value)
		food_entity.queue_free()
		setup_food_entity()

func _on_Snake_generated_tail_segment(segment: Node2D, segment_position: Vector2) -> void:
	add_child_below_node(player2, segment)
	grid.place_entity(segment, grid.world_to_map(segment_position))

func _on_Snake_body_segment_move_triggered(segment: Node2D, segment_position: Vector2) -> void:
	grid.move_entity_to_position(segment, segment_position)

func _on_Snake_size_changed(length: int, player_id: int) -> void:
	$UI.update_score(length, player_id)
