class_name GridUtility


var dimensions
var obstacles = Array()


func _init(dimens):
	dimensions = dimens


func _move_sequence_results(position, moves):
	for move in moves.sequence:
		if is_direction_valid(position, move):
			position = position_in_direction(position, move)
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
			var obstacle = _obstacle_at_position(result)
			if obstacle:
				if obstacle.type == GridObstacle.STICKY:
					results.append(result)
					break
				elif obstacle.type == GridObstacle.INVALID_END:
					pass
			else:
				results.append(result)
			last_pos = result
		else:
			break
		i += 1

	return results


func _batch_move_results(position, batch, repeat):
	var results = PoolVector2Array()
	for sequence in batch:
		var result = _calculate_move_sequence_results(position, sequence, repeat)
		if result:
			results += result
	
	return results


func _move_sequence_from_moves(moves):
	var sequence = MoveSequence.new()
	sequence.sequence = moves
	return sequence


func _distance_between_points(from, to):
	return


func _obstacle_at_position(position):
	for obstacle in obstacles:
		if obstacle.position == position:
			return obstacle
	return false


func convert_index_to_position(index):
	return


func convert_position_to_index(position):
	return


func position_in_direction(position, direction):
	return position + direction


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
	var result = position_in_direction(position, direction)
	return is_position_valid(result)


func get_all():
	return


func get_in_bounds(position, bounds):
	return


func get_pattern_results(position, pattern):
	return


func add_obstacle(obstacle):
	obstacles.append(obstacle)


func clear_obstacles():
	obstacles = Array()


func remove_obstacle(obstacle):
	obstacles.erase(obstacle)