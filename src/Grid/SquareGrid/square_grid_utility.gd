extends GridUtility

class_name SquareGridUtility


# ORTHOGONAL means only left, right, up, and down are counted as adjacent
# OCTILINEAR is ORTHOGONAL adjacency plus diagonals
enum {ORTHOGONAL, OCTILINEAR}


var adjacency_mode


func _init(dimens, adjacency = ORTHOGONAL).(dimens):
	adjacency_mode = adjacency


func _move_sequence_from_moves(moves):
	var sequence = SquareMoveSequence.new()
	sequence.sequence = moves
	return sequence


# Example: 3 in 2x2 grid -> (1, 1)
func convert_index_to_position(index):
	var x = index % int(dimensions.y)
	var y = index / int(dimensions.y)
	return Vector2(x, y)


# Example: (1, 1) in 2x2 grid -> 3
func convert_position_to_index(position):
	return position.x + (position.y * dimensions.y)


func is_edge(position):
	var horiz_edge = (position.x == 0) or (position.x == dimensions.x - 1)
	var vert_edge = (position.y == 0) or (position.y == dimensions.y - 1)
	return horiz_edge or vert_edge


func is_corner(position):
	var horiz_edge = (position.x == 0) or (position.x == dimensions.x - 1)
	var vert_edge = (position.y == 0) or (position.y == dimensions.y - 1)
	return horiz_edge and vert_edge


func get_adjacent(position):
	var orthogonal = MovePattern.new("R", MovePattern.ROTATE)
	var diagonal = MovePattern.new("RU", MovePattern.ROTATE)
	match adjacency_mode:
		ORTHOGONAL:
			return get_pattern_results(position, orthogonal)
		OCTILINEAR:
			return get_pattern_results(position, orthogonal) + get_pattern_results(position, diagonal)


func _generate_arc(position, distance):
	var arc = PoolVector2Array()
	for i in range(1, distance + 1):
		var sequence = str(i) + "U"
		if distance - i > 0:
			sequence +=  str(distance - i) + "R"
		var pattern = MovePattern.new(sequence, MovePattern.ROTATE)
		var results = get_pattern_results(position, pattern)
		arc += results
	return arc


func _generate_corner(position, distance):
	var corner = PoolVector2Array()
	for i in range(0, distance * 2):
		var sequence
		if i <= distance:
			sequence = str(distance) + "U"
			if i > 0:
				sequence +=  str(i) + "R"
		else:
			sequence = str(i - distance) + "U"
			sequence +=  str(distance) + "R"
		var pattern = MovePattern.new(sequence, MovePattern.ROTATE)
		var results = get_pattern_results(position, pattern)
		corner += results
	return corner


func get_at_distance(position, distance):
	match distance:
		0:
			var result = PoolVector2Array()
			result.append(position)
			return result
		1:
			return get_adjacent(position)
		_:
			if adjacency_mode == ORTHOGONAL:
				return _generate_arc(position, distance)
			elif adjacency_mode == OCTILINEAR:
				return _generate_corner(position, distance)


func is_position_valid(position):
	var within_x = (position.x >= 0) and (position.x < dimensions.x)
	var within_y = (position.y >= 0) and (position.y < dimensions.y)
	return within_x and within_y


func get_all():
	return get_in_bounds(Vector2(0, 0), Vector2(dimensions.x, dimensions.y))


func get_in_bounds(position, bounds):
	var results = PoolVector2Array()
	for i in range(bounds.y):
		for j in range(bounds.x):
			var point = position + Vector2(j, i)
			if is_position_valid(point):
				results.append(point)
	return results


func get_pattern_results(position, pattern):
	var batch = Array()
	batch.append(pattern.moves)
	
	match pattern.mode:
		MovePattern.NONE:
			pass
		MovePattern.ROTATE:
			for i in range(1, 4):
				var rotate = _move_sequence_from_moves(pattern.moves.get_rotation(i))
				batch.append(rotate)
		MovePattern.MIRROR_X:
			var mirror_x = _move_sequence_from_moves(pattern.moves.get_mirror_x())
			batch.append(mirror_x)
		MovePattern.MIRROR_Y:
			var mirror_y = _move_sequence_from_moves(pattern.moves.get_mirror_y())
			batch.append(mirror_y)
		MovePattern.MIRROR_XY:
			var mirror_x = _move_sequence_from_moves(pattern.moves.get_mirror_x())
			var mirror_y = _move_sequence_from_moves(pattern.moves.get_mirror_y())
			var mirror_xy = _move_sequence_from_moves(mirror_x.get_mirror_y())
			batch.append(mirror_x)
			batch.append(mirror_y)
			batch.append(mirror_xy)
		MovePattern.ROTATE_MIRROR:
			for i in range(1, 4):
				var rotate = _move_sequence_from_moves(pattern.moves.get_rotation(i))
				var mirror = _move_sequence_from_moves(rotate.get_mirror_x())
				batch.append(rotate)
				batch.append(mirror)
	
	return ._batch_move_results(position, batch, pattern.repeat)