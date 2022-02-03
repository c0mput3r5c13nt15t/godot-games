extends TileMap

class_name Grid

signal moved_into_death
signal moved_onto_food(food_entity, entity)

# Declare member variables here. Examples:
onready var half_cell_size = get_cell_size() / 2

onready var top_left: Vector2 = Vector2(7, 4)
onready var grid_size: Vector2 = Vector2(31, 20)
var grid: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_grid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func setup_grid() -> void:
	grid = []
	
	for x in range(grid_size.x):
		grid.append([])
		for _y in range(grid_size.y):
			grid[x].append(null)


func get_entity_of_cell(grid_pos: Vector2) -> Node2D:
	return grid[grid_pos.x-top_left.x][grid_pos.y-top_left.y] as Node2D


func set_entity_in_cell(entity: Node2D, grid_pos: Vector2) -> void:
	grid[grid_pos.x-top_left.x][grid_pos.y-top_left.y] = entity


func place_entity(entity: Node2D, grid_pos: Vector2) -> void:
	set_entity_in_cell(entity, grid_pos)
	entity.set_position(map_to_world(grid_pos) + half_cell_size)


func place_entity_at_random_pos(entity: Node2D) -> void:
	var has_random_pos: bool = false
	var random_grid_pos: Vector2
	
	while has_random_pos == false:
		
		var temp_pos: Vector2 = Vector2(randi() % int(grid_size.x-top_left.x) + top_left.x, randi() % int(grid_size.y-top_left.y)+top_left.y)
		if get_entity_of_cell(temp_pos) == null:
			random_grid_pos = temp_pos
			has_random_pos = true
	
	place_entity(entity, random_grid_pos)


func move_entity_in_direction(entity: Node2D, direction: Vector2) -> void:
	var old_grid_pos: Vector2 = world_to_map(entity.position)
	var new_grid_pos: Vector2 = old_grid_pos + direction

	if !is_cell_inside_bounds(new_grid_pos):
		setup_grid()
		emit_signal("moved_into_death")
		return
	
	set_entity_in_cell(null, old_grid_pos)
	
	var entity_of_new_cell: Node2D = get_entity_of_cell(new_grid_pos)
	if is_instance_valid(entity_of_new_cell) && entity_of_new_cell && entity_of_new_cell.is_in_group("Player"):
		setup_grid()
		emit_signal("moved_into_death")
		return
	elif is_instance_valid(entity_of_new_cell) && entity_of_new_cell && entity_of_new_cell.is_in_group("Food"):
		emit_signal("moved_onto_food", entity_of_new_cell, entity)

	place_entity(entity, new_grid_pos)


func move_entity_to_position(entity: Node2D, new_pos: Vector2) -> void:
	var old_grid_position: Vector2 = world_to_map(entity.position)
	var new_grid_position: Vector2 = world_to_map(new_pos)
	
	set_entity_in_cell(null, old_grid_position)
	place_entity(entity, new_grid_position)

	entity.set_position(new_pos)


func is_cell_inside_bounds(cell_pos: Vector2) -> bool:
	if((cell_pos.x - top_left.x) < grid_size.x and cell_pos.x >= top_left.x \
		and (cell_pos.y - top_left.y) < grid_size.y and cell_pos.y >= top_left.y):
			return true
	else:
		return false
