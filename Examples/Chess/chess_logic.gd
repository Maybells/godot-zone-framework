extends "res://src/GameLogic/base.gd"

class_name ChessLogic


enum {QUEEN, KING, PAWN, KNIGHT, ROOK, BISHOP}


var grid = SquareGridUtility.new(Vector2(8, 8))
var pawn_up = MovePattern.new("U")
var pawn_down = MovePattern.new("D")
var bishop = MovePattern.new("/RU", MovePattern.ROTATE, -1)
var rook = MovePattern.new("R", MovePattern.ROTATE, -1)
var knight = MovePattern.new("2RU", MovePattern.ROTATE_MIRROR)
var short_diag = MovePattern.new("/RU", MovePattern.ROTATE)
var short_orthog = MovePattern.new("R", MovePattern.ROTATE)

var move_possibilies = PoolVector2Array()


func _get_possibilities(piece):
	_generate_obstacles(piece)
	var possibilities = PoolVector2Array()
	var position = _position_of_zone(piece.origin_zone)
	match piece.type:
		PAWN:
			var pawn
			var pawn_diag
			
			if piece.is_white:
				pawn = pawn_up
				pawn_diag = MovePattern.new("/RU", MovePattern.MIRROR_X)
			else:
				pawn = pawn_down
				pawn_diag = MovePattern.new("/RD", MovePattern.MIRROR_X)
			
			if piece.first_move:
				pawn.repeat = 1
			else:
				pawn.repeat = 0
			
			possibilities += grid.get_pattern_results(position, pawn)
			if piece.pawn_diag:
				possibilities += grid.get_pattern_results(position, pawn_diag)
		KNIGHT:
			possibilities += grid.get_pattern_results(position, knight)
		ROOK:
			possibilities += grid.get_pattern_results(position, rook)
		BISHOP:
			possibilities += grid.get_pattern_results(position, bishop)
		KING:
			possibilities += grid.get_pattern_results(position, short_diag) + grid.get_pattern_results(position, short_orthog)
		QUEEN:
			possibilities += grid.get_pattern_results(position, bishop) + grid.get_pattern_results(position, rook)
	possibilities.append(_position_of_zone(piece.origin_zone))
	return possibilities


func _generate_obstacles(piece):
	grid.clear_obstacles()
	piece.pawn_diag = false
	
	for p in pieces:
		if p.is_white == piece.is_white:
			var obstacle = GridObstacle.new()
			
			if piece.type == KNIGHT:
				obstacle.type = GridObstacle.INVALID_END
			
			obstacle.position = _position_of_zone(p.origin_zone)
			grid.add_obstacle(obstacle)
		else:
			var obstacle = GridObstacle.new(GridObstacle.STICKY)
			obstacle.position = _position_of_zone(p.origin_zone)
			
			if piece.type == PAWN:
				if not _is_pawn_diagonal(obstacle.position, piece):
					obstacle.type = GridObstacle.IMPASSABLE
				else:
					piece.pawn_diag = true
			
			grid.add_obstacle(obstacle)


func _position_of_zone(zone):
	return grid.convert_index_to_position(zone.id)


func _is_pawn_diagonal(position, piece):
	var location = _position_of_zone(piece.origin_zone)
	if piece.is_white:
		return position == location + SquareMoveSequence.DIAG_UL or position == location + SquareMoveSequence.DIAG_UR
	else:
		return position == location + SquareMoveSequence.DIAG_DL or position == location + SquareMoveSequence.DIAG_DR


func is_move_valid(piece, start, end):
	if end:
		var possible = _get_possibilities(piece)
		var aim = _position_of_zone(end)
		if aim in possible and end.can_accept_piece(piece):
			return true
		return false
	else:
		return false


func move_piece(piece, to):
	.move_piece(piece, to)


func focus_piece(piece):
	move_possibilies = _get_possibilities(piece)
	.focus_piece(piece)


func unfocus_piece(piece):
	move_possibilies = PoolVector2Array()
	.unfocus_piece(piece)


func is_valid_endpoint(zone):
	var position = _position_of_zone(zone)
	return position in move_possibilies



