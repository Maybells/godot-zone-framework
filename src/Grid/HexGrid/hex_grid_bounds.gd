extends GridBounds

class_name HexGridBounds


enum {HEXAGONAL, RECTANGULAR}
enum {POINTY, FLAT}


var mode
var shape
var width
var height


func _init(dimensions: Vector2, mode = POINTY, shape = HEXAGONAL).(dimensions):
	self.mode = mode
	self.shape = shape
	width = int(dimensions.x)
	height = int(dimensions.y)


func _in_pointy_hexagonal(r, q):
	var dist_from_axis = q
	var start
	var end
	if dist_from_axis >= 0:
		start = -width + 1
		end = width - 1 - dist_from_axis
	else:
		start = -width + 1 - dist_from_axis
		end = width - 1
	return r >= start and r <= end


func _in_flat_hexagonal(r, q):
	var dist_from_axis = r
	var start
	var end
	if dist_from_axis >= 0:
		start = -height + 1
		end = height - 1 - dist_from_axis
	else:
		start = -height + 1 - dist_from_axis
		end = height - 1
	return q >= start and q <= end


func _in_pointy_rectangular(r, q):
	var start_y = -height / 2
	var end_y = start_y + height - 1
	
	# If offset is 0, then y = 0 and y = 1 have the same x value
	# If offset is -1, then y = -1 and y = 0 have the same x value
	var offset = -((height / 2) % 2)
	var y = q
	
	if offset == -1 and y == 1:
		y = 2
	elif offset == 0 and y == -1:
		y = -2
	
	var start_x = (-width / 2) - (y / 2)
	var end_x = start_x + width - 1
	return (r >= start_x and r <= end_x) and (q >= start_y and q <= end_y)


func _in_flat_rectangular(r, q):
	var start_x = -width / 2
	var end_x = start_x + width - 1
	
	# If offset is 0, then x = 0 and x = 1 have the same y value
	# If offset is -1, then x = -1 and x = 0 have the same y value
	var offset = -((width / 2) % 2)
	var x = r
	
	if offset == -1 and x == 1:
		x = 2
	elif offset == 0 and x == -1:
		x = -2
	
	var start_y = (-height / 2) - (x / 2)
	var end_y = start_y + height - 1
	return (r >= start_x and r <= end_x) and (q >= start_y and q <= end_y)


func is_in_bounds(position):
	var r = position.x
	var q = position.y
	if shape == HEXAGONAL:
		var within_height = q > -height and q < height
		var within_width = r > -width and r < width
		if not within_height or not within_width:
			return false
		
		if mode == POINTY:
			return _in_pointy_hexagonal(r, q)
		elif mode == FLAT:
			return _in_flat_hexagonal(r, q)
	elif shape == RECTANGULAR:
		if mode == POINTY:
			return _in_pointy_rectangular(r, q)
		elif mode == FLAT:
			return _in_flat_rectangular(r, q)
