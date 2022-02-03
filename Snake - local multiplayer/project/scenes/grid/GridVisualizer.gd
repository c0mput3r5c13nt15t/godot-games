extends Node2D

# Declare member variables here. Examples:
onready var grid: Grid = get_parent() as Grid

export var line_color: Color
export var line_thickness: int = 1


func _draw() -> void:
	for x in range(grid.grid_size.x):
		var start_point: Vector2 = Vector2(x * grid.cell_size.x, 0)
		var end_point: Vector2 = Vector2(x * grid.cell_size.x, grid.grid_size.y * grid.cell_size.y)
		draw_line(start_point, end_point, line_color, line_thickness)
	
	for y in range(grid.grid_size.y):
		var start_point: Vector2 = Vector2(0, y * grid.cell_size.y)
		var end_point: Vector2 = Vector2(grid.grid_size.x * grid.cell_size.x, y * grid.cell_size.y)
		draw_line(start_point, end_point, line_color, line_thickness)