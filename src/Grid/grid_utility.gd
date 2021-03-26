class_name GridUtility


# ORTHOGONAL means only left, right, up, and down are counted as adjacent
# OCTILINEAR is ORTHOGONAL adjacency plus diagonals
enum {ORTHOGONAL, OCTILINEAR}

# NONE will not mirror or rotate moves
# MIRROR_X mirrors across the y axis
# MIRROR_Y mirrors across the x axis
# MIRROR_XY mirrors across the x and y axes
# ROTATE mirrors radially
# ROTATE_MIRROR mirrors radially and across the radius
enum {NONE, MIRROR_X, MIRROR_Y, MIRROR_XY, ROTATE, ROTATE_MIRROR}


var dimensions
var adjacency_mode

func _init(dimens, adjacency = ORTHOGONAL):
	dimensions = dimens
	adjacency_mode = adjacency


func _position_in_direction(position, direction):
	return position + direction


func _move_sequence_results(position, moves):
	for move in moves.sequence:
		if is_direction_valid(position, move):
			position += move
		else:
			return false
	return position


func _calculate_move_sequence_results(position, moves, repeat):
	var results = PoolVector2Array()
	var last_pos = position
	var i = 0
	while i <= repeat or repeat == -1:
		var result = _move_sequence_results(last_pos, moves)
		if result or result is Vector2:
			results.append(result)
			last_pos = result
		else:
			break
		i += 1
	
	if not results:
		return false
	return results


# Turns a 1d array index into a 2d one
# Example: 3 in 2x2 grid -> (1, 1)
func convert_1d_to_2d(index):
	var x = index % dimensions.y
	var y = index / dimensions.y
	return Vector2(x, y)


# Turns a 2d array index into a 1d one
# Example: (1, 1) in 2x2 grid -> 3
func convert_2d_to_1d(position):
	return position.x + (position.y * dimensions.y)


func is_edge(position):
	var horiz_edge = (position.x == 0) or (position.x == dimensions.x - 1)
	var vert_edge = (position.y == 0) or (position.y == dimensions.y - 1)
	return horiz_edge or vert_edge


func is_corner(position):
	var horiz_edge = (position.x == 0) or (position.x == dimensions.x - 1)
	var vert_edge = (position.y == 0) or (position.y == dimensions.y - 1)
	return horiz_edge and vert_edge


func generate_moves(string):
	return GridMoveSequence.new(string)


func get_adjacent(position):
	match adjacency_mode:
		ORTHOGONAL:
			return move_pattern_results(position, generate_moves("R"), ROTATE)
		OCTILINEAR:
			return move_pattern_results(position, generate_moves("R"), ROTATE) + move_pattern_results(position, generate_moves("R"), ROTATE)


func _generate_arc(position, distance):
	var arc = Array()
	for i in range(1, distance + 1):
		var sequence = str(i) + "U"
		if distance - i > 0:
			sequence +=  str(distance - i) + "R"
		var move = generate_moves(sequence)
		arc += Array(_get_rotations(move))
		
	var results = PoolVector2Array()
	for move in arc:
		var result = move_pattern_results(position, move)
		if result:
			results += result
	return results


func get_at_distance(position, distance):
	match distance:
		0:
			var result = PoolVector2Array()
			result.append(position)
			return result
		1:
			return get_adjacent(position)
		_:
			return _generate_arc(position, distance)


func get_distance_range(position, lower, upper):
	var results = PoolVector2Array()
	for i in range(lower, upper + 1):
		results += get_at_distance(position, i)
	return results


func get_within_distance(position, dist):
	return get_distance_range(position, 0, dist)


func is_position_valid(position):
	var within_x = (position.x >= 0) and (position.x < dimensions.x)
	var within_y = (position.y >= 0) and (position.y < dimensions.y)
	return within_x and within_y


func is_direction_valid(position, direction):
	var result = _position_in_direction(position, direction)
	return is_position_valid(result)


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


func move_pattern_results(position, moves, mirroring_mode = NONE, repeat = 0):
	var batch
	match mirroring_mode:
		NONE:
			return _calculate_move_sequence_results(position, moves, repeat)
		ROTATE:
			batch = _get_rotations(moves)
		MIRROR_X:
			batch = _get_mirror_x(moves)
		MIRROR_Y:
			batch = _get_mirror_y(moves)
		MIRROR_XY:
			batch = _get_mirror_xy(moves)
		ROTATE_MIRROR:
			batch = _get_mirror_rotations(moves)
	return _batch_move_results(position, batch, repeat)


# Replaces all move A's in the sequence with B's and vice versa
func _switch_moves(sequence, a, b):
	var replacement = Array()
	for move in sequence:
		if move == a:
			replacement.append(b)
		elif move == b:
			replacement.append(a)
		else:
			replacement.append(move)
	return replacement


func _rotate_moves(moves):
	var replacement = PoolVector2Array()
	for move in moves:
		if move == GridMoveSequence.LEFT:
			replacement.append(GridMoveSequence.DOWN)
		elif move == GridMoveSequence.RIGHT:
			replacement.append(GridMoveSequence.UP)
		elif move == GridMoveSequence.UP:
			replacement.append(GridMoveSequence.LEFT)
		elif move == GridMoveSequence.DOWN:
			replacement.append(GridMoveSequence.RIGHT)
	return replacement


func _get_rotations(moves):
	var rotations = Array()
	var last_moves = moves.sequence
	for i in range(4):
		var rot = _rotate_moves(last_moves)
		var rotation = GridMoveSequence.new()
		rotation.sequence = rot
		rotations.append(rotation)
		last_moves = rot
	
	return rotations


func _get_mirror_rotations(moves):
	var rotations = Array()
	var last_moves = moves.sequence
	for i in range(4):
		var rot = _rotate_moves(last_moves)
		var rotation = GridMoveSequence.new()
		rotation.sequence = rot
		var mirror = _mirror_x(rotation)
		rotations.append(rotation)
		rotations.append(mirror)
		last_moves = rot
	
	return rotations


func _mirror_x(moves):
	var mirror = GridMoveSequence.new()
	mirror.sequence = _switch_moves(moves.sequence, GridMoveSequence.LEFT, GridMoveSequence.RIGHT)
	return mirror


func _mirror_y(moves):
	var mirror = GridMoveSequence.new()
	mirror.sequence = _switch_moves(moves.sequence, GridMoveSequence.UP, GridMoveSequence.DOWN)
	return mirror


func _get_mirror_x(moves):
	var mirrors = Array()
	mirrors.append(moves)
	mirrors.append(_mirror_x(moves))
	return mirrors


func _get_mirror_y(moves):
	var mirrors = Array()
	mirrors.append(moves)
	mirrors.append(_mirror_y(moves))
	return mirrors


func _get_mirror_xy(moves):
	var mirrors = Array()
	mirrors.append(moves)
	var mirror_y = _mirror_y(moves)
	mirrors.append(mirror_y)
	mirrors.append(_mirror_x(moves))
	mirrors.append(_mirror_x(mirror_y))
	return mirrors


func _batch_move_results(position, batch, repeat):
	var results = PoolVector2Array()
	for sequence in batch:
		var result = _calculate_move_sequence_results(position, sequence, repeat)
		if result:
			results += result
	
	if not results:
		return false
	return results