extends Grid

class_name HexGrid


func _init(dimens).(HexGridBounds.new(dimens)):
	pass


func _move_sequence_from_moves(moves):
#	var sequence = SquareMoveSequence.new()
#	sequence.sequence = moves
#	return sequence
	pass


func _distance_between_points(from, to):
	pass


func convert_index_to_position(index):
	pass


func convert_position_to_index(position):
	pass


func get_distance_range(position, lower, upper):
#	var results = PoolVector2Array()
#	var width = (2 * upper) + 1
#	var top_corner = Vector2(position.x - upper, position.y - upper)
#	for i in range(width):
#		for j in range(width):
#			var point = Vector2(j, i)
#			point += top_corner
#			if is_position_valid(point):
#				var dist = _distance_between_points(position, point)
#				if dist >= lower and dist <= upper:
#					results.append(point)
#	return results
	pass


func get_all():
	pass #return get_in_dimens(Vector2(0, 0), Vector2(bounds.x, bounds.y))


func get_in_dimens(position, dimens):
#	var results = PoolVector2Array()
#	for i in range(dimens.y):
#		for j in range(dimens.x):
#			var point = position + Vector2(j, i)
#			if is_position_valid(point):
#				results.append(point)
#	return results
	pass


func get_pattern_results(position, pattern):
#	var batch = Array()
#	batch.append(pattern.moves)
#
#	match pattern.mode:
#		MovePattern.NONE:
#			pass
#		MovePattern.ROTATE:
#			for i in range(1, 4):
#				var rotate = _move_sequence_from_moves(pattern.moves.get_rotation(i))
#				batch.append(rotate)
#		MovePattern.MIRROR_X:
#			var mirror_x = _move_sequence_from_moves(pattern.moves.get_mirror_x())
#			batch.append(mirror_x)
#		MovePattern.MIRROR_Y:
#			var mirror_y = _move_sequence_from_moves(pattern.moves.get_mirror_y())
#			batch.append(mirror_y)
#		MovePattern.MIRROR_XY:
#			var mirror_x = _move_sequence_from_moves(pattern.moves.get_mirror_x())
#			var mirror_y = _move_sequence_from_moves(pattern.moves.get_mirror_y())
#			var mirror_xy = _move_sequence_from_moves(mirror_x.get_mirror_y())
#			batch.append(mirror_x)
#			batch.append(mirror_y)
#			batch.append(mirror_xy)
#		MovePattern.ROTATE_MIRROR:
#			var mirror = _move_sequence_from_moves(pattern.moves.get_mirror_x())
#			batch.append(mirror)
#			for i in range(1, 4):
#				var rotate = _move_sequence_from_moves(pattern.moves.get_rotation(i))
#				mirror = _move_sequence_from_moves(rotate.get_mirror_x())
#				batch.append(rotate)
#				batch.append(mirror)
#
#	return ._batch_move_results(position, batch, pattern.repeat)
	pass
