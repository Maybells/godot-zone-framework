extends "res://src/GameLogic/base.gd"

class_name ChessLogic


enum {QUEEN, KING, PAWN, KNIGHT, ROOK, BISHOP}
const WHITE = true
const BLACK = false


signal turn_changed(current_turn)
signal game_ended(winner)
signal king_checked(color)
signal king_not_checked(color)


var grid = SquareGridUtility.new(Vector2(8, 8))
var pawn_up = MovePattern.new("U")
var pawn_down = MovePattern.new("D")
var bishop = MovePattern.new("/RU", MovePattern.ROTATE, -1)
var rook = MovePattern.new("R", MovePattern.ROTATE, -1)
var knight = MovePattern.new("2RU", MovePattern.ROTATE_MIRROR)
var short_diag = MovePattern.new("/RU", MovePattern.ROTATE)
var short_orthog = MovePattern.new("R", MovePattern.ROTATE)

var move_possibilies = PoolVector2Array()
var current_turn = WHITE
var game_ongoing = true


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
				if piece.pawn_diag_left and piece.pawn_diag_right:
					pawn_diag = MovePattern.new("/RU", MovePattern.MIRROR_X)
				elif piece.pawn_diag_left:
					pawn_diag = MovePattern.new("/LU")
				elif piece.pawn_diag_right:
					pawn_diag = MovePattern.new("/RU")
			else:
				pawn = pawn_down
				if piece.pawn_diag_left and piece.pawn_diag_right:
					pawn_diag = MovePattern.new("/RD", MovePattern.MIRROR_X)
				elif piece.pawn_diag_left:
					pawn_diag = MovePattern.new("/LD")
				elif piece.pawn_diag_right:
					pawn_diag = MovePattern.new("/RD")
			
			if piece.first_move:
				pawn.repeat = 1
			else:
				pawn.repeat = 0
			
			possibilities += grid.get_pattern_results(position, pawn)
			if piece.pawn_diag_left or piece.pawn_diag_right:
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
	piece.pawn_diag_left = false
	piece.pawn_diag_right = false
	
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
				elif obstacle.position.x > _position_of_zone(piece.origin_zone).x:
					piece.pawn_diag_right = true
				elif obstacle.position.x < _position_of_zone(piece.origin_zone).x:
					piece.pawn_diag_left = true
			
			grid.add_obstacle(obstacle)


func _position_of_zone(zone):
	return grid.convert_index_to_position(zone.id)


func _is_pawn_diagonal(position, piece):
	var location = _position_of_zone(piece.origin_zone)
	if piece.is_white:
		return position == location + SquareMoveSequence.DIAG_UL or position == location + SquareMoveSequence.DIAG_UR
	else:
		return position == location + SquareMoveSequence.DIAG_DL or position == location + SquareMoveSequence.DIAG_DR


func _is_in_check(color):
	var king_position
	
	for p in pieces:
		if p.is_white == color and p.type == KING:
			king_position = _position_of_zone(p.origin_zone)
	
	for p in pieces:
		if p.is_white != color and king_position:
			var attack = _get_possibilities(p)
			if king_position in attack:
				return true
	return false


func _next_turn():
	if game_ongoing:
		current_turn = not current_turn
		emit_signal("turn_changed", current_turn)


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
	if to == piece.origin_zone:
		piece.return_to_origin()
		return
	
	.move_piece(piece, to)
	_next_turn()
	if _is_in_check(current_turn):
		emit_signal("king_checked", current_turn)
	if not _is_in_check(not current_turn):
		emit_signal("king_not_checked", not current_turn)


func can_focus(piece):
	return piece.is_white == current_turn and game_ongoing


func focus_piece(piece):
	move_possibilies = _get_possibilities(piece)
	.focus_piece(piece)


func unfocus_piece(piece):
	move_possibilies = PoolVector2Array()
	.unfocus_piece(piece)


func is_valid_endpoint(zone):
	var position = _position_of_zone(zone)
	return position in move_possibilies

func end_game():
	game_ongoing = false
	emit_signal("game_ended", current_turn)

