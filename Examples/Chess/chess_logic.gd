extends GameLogic

class_name ChessLogic


enum {QUEEN, KING, PAWN, KNIGHT, ROOK, BISHOP}
const WHITE = true
const BLACK = false


signal turn_changed(current_turn)
signal game_ended(winner)
signal king_checked(color)
signal king_not_checked(color)


var grid = SquareGrid.new(Vector2(8, 8))
var pawn_up = MovePattern.new("U")
var pawn_down = MovePattern.new("D")
var bishop = MovePattern.new("/RU", MovePattern.ROTATE, -1)
var rook = MovePattern.new("R", MovePattern.ROTATE, -1)
var knight = MovePattern.new("2RU", MovePattern.ROTATE_MIRROR)
var short_diag = MovePattern.new("/RU", MovePattern.ROTATE)
var short_orthog = MovePattern.new("R", MovePattern.ROTATE)

var current_turn = WHITE
var game_ongoing = true


func _get_possibilities(piece):
	reset_effect("move_possibilities")
	reset_effect("move_origin")
	
	_generate_obstacles(piece)
	var attacks = _get_possible_attacks(piece)
	
	set_effect("move_possibilities", attacks)
	set_effect("move_origin", [_position_of_zone(piece.zone)])
	update_effects()


func _get_possible_attacks(piece):
	_generate_obstacles(piece)
	var possibilities = PoolVector2Array()
	var position = _position_of_zone(piece.zone)
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
			
			obstacle.position = _position_of_zone(p.zone)
			grid.add_obstacle(obstacle)
		else:
			var obstacle = GridObstacle.new(GridObstacle.STICKY)
			obstacle.position = _position_of_zone(p.zone)
			
			if piece.type == PAWN:
				if not _is_pawn_diagonal(obstacle.position, piece):
					obstacle.type = GridObstacle.IMPASSABLE
				elif obstacle.position.x > _position_of_zone(piece.zone).x:
					piece.pawn_diag_right = true
				elif obstacle.position.x < _position_of_zone(piece.zone).x:
					piece.pawn_diag_left = true
			
			grid.add_obstacle(obstacle)


func _position_of_zone(zone):
	return grid.convert_index_to_position(zone.id)


func _is_pawn_diagonal(position, piece):
	var location = _position_of_zone(piece.zone)
	if piece.is_white:
		return position == location + SquareMoveSequence.DIAG_UL or position == location + SquareMoveSequence.DIAG_UR
	else:
		return position == location + SquareMoveSequence.DIAG_DL or position == location + SquareMoveSequence.DIAG_DR


func _is_in_check(color):
	var king_position
	
	for p in pieces:
		if p.is_white == color and p.type == KING:
			king_position = _position_of_zone(p.zone)
	
	for p in pieces:
		if p.is_white != color and king_position:
			var attack = _get_possible_attacks(p)
			if king_position in attack:
				return true
	return false


func _next_turn():
	if game_ongoing:
		current_turn = not current_turn
		emit_signal("turn_changed", current_turn)
		get_tree().call_group("Black", "set_enabled", current_turn == BLACK)
		get_tree().call_group("White", "set_enabled", current_turn == WHITE)


func is_move_valid(piece, start, end):
	if end:
		var aim = _position_of_zone(end)
		if (has_effect("move_possibilities", aim) or has_effect("move_origin", aim)) and end.can_accept_piece(piece):
			return true
		return false
	else:
		return false


func move_piece(piece, to):
	if to == piece.zone:
		piece.return_to_origin()
		return
	
	.move_piece(piece, to)
	_next_turn()
	if _is_in_check(current_turn):
		emit_signal("king_checked", current_turn)
	if not _is_in_check(not current_turn):
		emit_signal("king_not_checked", not current_turn)


func piece_picked_up(piece):
	_get_possibilities(piece)


func piece_put_down(piece):
	reset_effect("move_possibilities")
	reset_effect("move_origin")
	update_effects()


func is_valid_endpoint(zone):
	var position = _position_of_zone(zone)
	return has_effect("move_possibilities", position) or has_effect("move_origin", position)


func end_game():
	game_ongoing = false
	emit_signal("game_ended", current_turn)

