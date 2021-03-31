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


func _ready():
	pass


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
	var a
	var b
	var horiz
	if height > width or (height == width and type == variant.FLAT):
		a = height
		b = width
		horiz = false
	else:
		a = width
		b = height
		horiz = true
	
	var short = (2 * b) - 1
	var long = (2 * a) - 1
	
	for i in range(short):
		var r = (-short / 2) + i
		var l = long - abs(r)
		
		for j in range(l):
			var q
			if i < b:
				q = a - l + j
			else:
				q = (-long / 2) + j
			
			if horiz:
				points.append(Vector2(q, r))
			else:
				points.append(Vector2(r, q))
	return points


func cell_margin_set(value):
	cell_margin = value
	_generate_grid()


func type_set(value):
	type = value
	_generate_grid()


func width_set(value):
	width = value
	_generate_grid()


func height_set(value):
	height = value
	_generate_grid()


func rectangular_set(value):
	rectangular = value
	_generate_grid()