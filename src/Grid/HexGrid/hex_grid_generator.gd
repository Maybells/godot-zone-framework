tool
extends Node2D


enum variant {FLAT, POINTY}


export (variant) var type setget type_set
export (bool) var rectangular = false setget rectangular_set
export (int, 1, 1000000) var width = 3 setget width_set
export (int, 1, 1000000) var height = 3 setget height_set
export (int, 1, 1000000) var cell_size = 16 setget cell_size_set
export (int) var cell_margin = 2 setget cell_margin_set
var points = PoolVector2Array()
var colors = PoolColorArray([Color.white])


func _draw():
	if Engine.editor_hint:
		var label = Label.new()
		var font = label.get_font("")
		for point in points:
			var position = _hex_to_position(point)
			draw_polygon(_hex(position), colors)
			draw_circle(position, 4, Color(255, 0, 0))
			draw_string(font, position, str(point), Color.black)
		label.free()


func _hex(position):
	var shape = PoolVector2Array()
	for i in range(6):
		var angle_deg
		if type == variant.FLAT:
			angle_deg = 60 * i
		elif type == variant.POINTY:
			angle_deg = 60 * i - 30
		var angle_rad = PI / 180 * angle_deg
		var point = Vector2(position.x + cell_size * cos(angle_rad), position.y + cell_size * sin(angle_rad))
		shape.append(point)
	return shape


func _index_to_hex(index):
	pass


func _hex_to_position(hex):
	var q = hex.x
	var r = hex.y
	if type == variant.FLAT:
		var x = (cell_size + cell_margin) * (1.5 * q)
		var y = (cell_size + cell_margin) * (sqrt(3) * r + sqrt(3)/2.0 * q)
		return Vector2(x, y)
	elif type == variant.POINTY:
		var x = (cell_size + cell_margin) * (sqrt(3) * q + sqrt(3)/2.0 * r)
		var y = (cell_size + cell_margin) * (1.5 * r)
		return Vector2(x, y)


func _generate_grid():
	points = PoolVector2Array()
	if rectangular:
		_generate_rectangular()
	else:
		_generate_hexagonal()
	
	update()


func cell_size_set(value):
	cell_size = value
	_generate_grid()


func _generate_rectangular():
	if type == variant.POINTY:
		_generate_pointy_rectangular()
	elif type == variant.FLAT:
		_generate_flat_rectangular()


func _generate_pointy_rectangular():
	for i in range(height):
		var r = (-height / 2) + i
		var l = width
		
		for j in range(l):
			var q = (-width / 2) + j - (i / 2) + 0 + (height / 4)
			points.append(Vector2(q, r))


func _generate_flat_rectangular():
	for i in range(width):
		var r = (-width / 2) + i
		var l = height
		
		for j in range(l):
			var q = (-height / 2) + j - (i / 2) + (width / 4)
			points.append(Vector2(r, q))


func _generate_hexagonal():
	if type == variant.POINTY:
		_generate_pointy_hexagonal()
	elif type == variant.FLAT:
		_generate_flat_hexagonal()


func _generate_pointy_hexagonal():
	var rows = (2 * height) - 1
	var columns = (2 * width) - 1
	
	for i in range(rows):
		var r = (-rows / 2) + i
		var l = columns - abs(r)
		
		for j in range(l):
			var q
			if i < height:
				q = width - l + j
			else:
				q = (-columns / 2) + j
			
			points.append(Vector2(q, r))


func _generate_flat_hexagonal():
	var rows = (2 * height) - 1
	var columns = (2 * width) - 1
	
	for i in range(columns):
		var r = (-columns / 2) + i
		var l = rows - abs(r)
		
		for j in range(l):
			var q
			if i < width:
				q = height - l + j
			else:
				q = (-rows / 2) + j
			
			points.append(Vector2(r, q))


func get_bounds():
	var mode
	var shape
	
	if rectangular:
		shape = HexGridBounds.RECTANGULAR
	else:
		shape = HexGridBounds.HEXAGONAL
	
	if type == variant.POINTY:
		mode = HexGridBounds.POINTY
	if type == variant.FLAT:
		mode = HexGridBounds.FLAT
	
	return HexGridBounds.new(Vector2(width, height), mode, shape)


func cell_margin_set(value):
	cell_margin = value
	_generate_grid()


func type_set(value):
	type = value
	_generate_grid()


func width_set(value):
	if not rectangular and type == variant.FLAT:
		width = min(value, height * 2 - 1)
	else:
		width = value
	_generate_grid()


func height_set(value):
	if not rectangular and type == variant.POINTY:
		height = min(value, width * 2 - 1)
	else:
		height = value
	_generate_grid()


func rectangular_set(value):
	rectangular = value
	_generate_grid()