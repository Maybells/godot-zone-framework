class_name GridUtility


var dimensions


func _init(dimens):
	dimensions = dimens


func _position_in_direction(position, direction):
	return position + direction


func _move_sequence_results(position, moves):
	for move in moves.sequence:
		if is_direction_valid(position, move):
			position = _position_in_direction(position, move)
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


func _batch_move_results(position, batch, repeat):
	var results = PoolVector2Array()
	for sequence in batch:
		var result = _calculate_move_sequence_results(position, sequence, repeat)
		if result:
			results += result
	
	if not results:
		return false
	return results


func _move_sequence_from_moves(moves):
	var sequence = MoveSequence.new()
	sequence.sequence = moves
	return sequence


func _distance_between_points(from, to):
	return


func convert_index_to_position(index):
	return


func convert_position_to_index(position):
	return


func get_adjacent(position):
	return get_at_distance(position, 1)


func get_at_distance(position, distance):
	if distance == 0:
		return position
	return get_distance_range(position, distance, distance)


func get_distance_range(position, lower, upper):
	return


func get_within_distance(position, distance):
	return get_distance_range(position, 0, distance)


func is_position_valid(position):
	return false


func is_direction_valid(position, direction):
	var result = _position_in_direction(position, direction)
	return is_position_valid(result)


func get_all():
	return


func get_in_bounds(position, bounds):
	return


func get_pattern_results(position, pattern):
	return