extends GridBounds

class_name SquareGridBounds


var x setget ,_x_get
var y setget ,_y_get


func _init(dimensions: Vector2).(dimensions):
	pass


func _x_get():
	return dimensions.x


func _y_get():
	return dimensions.y


func is_in_bounds(position):
	var within_x = (position.x >= 0) and (position.x < dimensions.x)
	var within_y = (position.y >= 0) and (position.y < dimensions.y)
	return within_x and within_y


func is_edge(position):
	var horiz_edge = (position.x == 0) or (position.x == dimensions.x - 1)
	var vert_edge = (position.y == 0) or (position.y == dimensions.y - 1)
	return horiz_edge or vert_edge


func is_corner(position):
	var horiz_edge = (position.x == 0) or (position.x == dimensions.x - 1)
	var vert_edge = (position.y == 0) or (position.y == dimensions.y - 1)
	return horiz_edge and vert_edge
