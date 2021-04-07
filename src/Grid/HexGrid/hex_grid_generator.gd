tool
extends Node2D


export (int, "Pointy", "Flat") var type setget type_set
export (int, "Hexagonal", "Rectangular") var shape = false setget shape_set
export (int, 1, 1000000) var width = 3 setget width_set
export (int, 1, 1000000) var height = 3 setget height_set
export (int, 1, 1000000) var cell_size = 16 setget cell_size_set
export (int) var cell_margin = 2 setget cell_margin_set
export (Color) var color = Color.white setget color_set
var bounds = HexGridBounds.new(Vector2())
var points = PoolVector2Array()
var colors = PoolColorArray([color])


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
		if type == HexGridBounds.FLAT:
			angle_deg = 60 * i
		elif type == HexGridBounds.POINTY:
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
	if type == HexGridBounds.FLAT:
		var x = (cell_size + cell_margin) * (1.5 * q)
		var y = (cell_size + cell_margin) * (sqrt(3) * r + sqrt(3)/2.0 * q)
		return Vector2(x, y)
	elif type == HexGridBounds.POINTY:
		var x = (cell_size + cell_margin) * (sqrt(3) * q + sqrt(3)/2.0 * r)
		var y = (cell_size + cell_margin) * (1.5 * r)
		return Vector2(x, y)


func _generate_grid():
	bounds = HexGridBounds.new(Vector2(width, height), type, shape)
	
	points = PoolVector2Array()
	if bounds.shape == HexGridBounds.RECTANGULAR:
		_generate_rectangular()
	else:
		_generate_hexagonal()
	
	update()


func cell_size_set(value):
	cell_size = value
	_generate_grid()


func _generate_rectangular():
	if bounds.mode == HexGridBounds.POINTY:
		_generate_pointy_rectangular()
	elif bounds.mode == HexGridBounds.FLAT:
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
	if bounds.mode == HexGridBounds.POINTY:
		_generate_pointy_hexagonal()
	elif bounds.mode == HexGridBounds.FLAT:
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
	return bounds


func cell_margin_set(value):
	cell_margin = value
	_generate_grid()


func type_set(value):
	type = value
	_generate_grid()


func width_set(value):
	if shape == HexGridBounds.HEXAGONAL and type == HexGridBounds.FLAT:
		width = min(value, height * 2 - 1)
	else:
		width = value
	_generate_grid()


func height_set(value):
	if shape == HexGridBounds.HEXAGONAL and type == HexGridBounds.POINTY:
		height = min(value, width * 2 - 1)
	else:
		height = value
	_generate_grid()


func shape_set(value):
	shape = value
	_generate_grid()


func color_set(value):
	color = value
	colors = PoolColorArray([color])
	update()
