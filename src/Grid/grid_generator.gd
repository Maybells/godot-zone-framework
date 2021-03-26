tool
extends Node2D


export (int, 1, 1000000) var columns = 1 setget columns_set
export (int, 1, 1000000) var rows = 1 setget rows_set
export (Vector2) var cell_size = Vector2(16, 16) setget cell_size_set
export (Vector2) var cell_margin = Vector2(2, 2) setget cell_margin_set
var points = PoolVector2Array()


func _ready():
	var g = GridUtility.new(Vector2(columns, rows))
	print(g.move_pattern_results(Vector2(2, 2), g.generate_moves("LLU"), GridUtility.ROTATE_MIRROR))


func _draw():
	if true or Engine.editor_hint:
		for point in points:
			var corner = Vector2(point.x - (cell_size.x/2.0), point.y - (cell_size.y/2.0))
			draw_rect(Rect2(corner, cell_size), Color(255, 255, 255))
			draw_circle(point, 1, Color(255, 0, 0))


func _generate_grid():
	var width = (cell_size.x * columns) + (cell_margin.x * columns)
	var height = (cell_size.y * rows) + (cell_margin.y * rows)
	var column_width = float(width) / columns
	var column_height = float(height) / rows
	points = PoolVector2Array()
	for i in range(0, rows):
		for j in range(0, columns):
			var x = ((-width + column_width)  / 2.0) + (j * column_width)
			var y = ((-height + column_height)  / 2.0) + (i * column_height)
			points.append(Vector2(x, y))
	update()


func cell_size_set(value):
	cell_size = value
	_generate_grid()


func cell_margin_set(value):
	cell_margin = value
	_generate_grid()


func columns_set(value):
	columns = value
	_generate_grid()


func rows_set(value):
	rows = value
	_generate_grid()