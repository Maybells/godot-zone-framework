extends GridGameLogic

class_name ChessLogic


enum {QUEEN, KING, PAWN, KNIGHT, ROOK, BISHOP}
const WHITE = true
const BLACK = false


signal turn_changed(current_turn)
signal game_ended(winner)
signal king_checked(color)
signal king_not_checked(color)


var current_turn = WHITE
var game_ongoing = true

var boundaries = SquareGridBounds.new(Vector2(8, 8))
var chess_grid = SquareGrid.new(boundaries)


func _init().(chess_grid):
	create_effect("move_possibilities")
	create_effect("move_origin")


func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		var testing = SquareMovePattern.new("R", SquareMovePattern.ROTATE_FULL, 1)
		var paths = grid.pattern_results(Vector2(0, 0), testing)
#	elif Input.is_action_just_pressed("ui_down"):
#		update_effect("testing")


func _get_possibilities(piece):
	reset_effect("move_possibilities")
	reset_effect("move_origin")
	
#	_generate_obstacles(piece)
#	var attacks = _get_possible_attacks(piece)
#
#	set_effect("move_possibilities", attacks)
#	set_effect("move_origin", [_position_of_zone(piece.zone)])
#	update_effects()


func _get_possible_moves(piece):
	var patterns = piece.get_move_patterns()
	var start = piece.zone.location
	var moves = []
	for pattern in patterns:
		var without_obstacles = grid.get_travelled_points(start, pattern)
		var obstacles = []
		for point in without_obstacles:
			var tile = get_zone_at(point)
			
			obstacles += obstacles_in(tile.id, {"type": piece.type, "color": piece.is_white, "start": start})
		var with_obstacles = grid.resolve_pattern(start, pattern, obstacles)
		moves += with_obstacles
	return moves


func _highlight_moves(piece):
	reset_effect("move_possibilities")
	reset_effect("move_origin")
	
	var moves = _get_possible_moves(piece)
	
	for path in moves:
		if not path.failed:
			add_to_effect("move_possibilities", path.end_position)
	
	add_to_effect("move_origin", piece.zone.location)
	
	update_effect("move_possibilities")
	update_effect("move_origin")


# Returns an array of obstacles at the given zone
func obstacles_in(zone_id, params := {}) -> Array:
	var zone = zones[zone_id]
	if zone.location == params["start"]:
		return []
	
	var type = params["type"]
	var color = params["color"]
	var obstacles = []
	if type == ROOK or type == BISHOP or type == QUEEN or type == KING:
		for piece in zone.pieces:
			var obstacle
			if piece.is_white == color:
				obstacle = GridObstacle.new(zone.location, GridObstacle.BLOCK)
			else:
				obstacle = GridObstacle.new(zone.location, GridObstacle.STICKY)
			obstacles.append(obstacle)
	elif type == KNIGHT:
		for piece in zone.pieces:
			var obstacle
			if piece.is_white == color:
				obstacle = GridObstacle.new(zone.location, GridObstacle.INVALID_END)
				obstacles.append(obstacle)
	elif type == PAWN:
		var pos = params["start"]
		var obstacle
		for piece in zone.pieces:
			if zone.location.x == pos.x or piece.color == color:
				obstacle = GridObstacle.new(zone.location, GridObstacle.BLOCK)
				obstacles.append(obstacle)
		if zone.location.x != pos.x and zone.pieces.empty():
			obstacle = GridObstacle.new(zone.location, GridObstacle.BLOCK)
			obstacles.append(obstacle)
	
	return obstacles


func _get_possible_attacks(piece):
	pass


func _position_of_zone(zone):
	pass


func _is_pawn_diagonal(position, piece):
	return false
#	var location = _position_of_zone(piece.zone)
#	if piece.is_white:
#		return position == location + SquareMoveSequence.DIAG_UL or position == location + SquareMoveSequence.DIAG_UR
#	else:
#		return position == location + SquareMoveSequence.DIAG_DL or position == location + SquareMoveSequence.DIAG_DR


func _is_in_check(color):
	return false


func _next_turn():
	if game_ongoing:
		current_turn = not current_turn
		emit_signal("turn_changed", current_turn)
		get_tree().call_group("Black", "set_enabled", current_turn == BLACK)
		get_tree().call_group("White", "set_enabled", current_turn == WHITE)


func is_move_valid(piece, start, end):
	if not end:
		return false
	
	if start == end:
		return true
	
	var valid_moves = _get_possible_moves(piece)
	for path in valid_moves:
		if not path.failed and path.end_position == end.location:
			return true
	return false


func move_piece(piece, to):
	if to == piece.zone:
		piece.return_to_zone()
		return
	
	.move_piece(piece, to)
	_next_turn()
	if _is_in_check(current_turn):
		emit_signal("king_checked", current_turn)
	if not _is_in_check(not current_turn):
		emit_signal("king_not_checked", not current_turn)


func piece_picked_up(piece):
	_highlight_moves(piece)


func piece_put_down(piece):
	reset_effect("move_possibilities")
	reset_effect("move_origin")
	update_effect("move_possibilities")
	update_effect("move_origin")


func is_valid_endpoint(zone):
	var position = _position_of_zone(zone)
	return has_effect("move_possibilities", position) or has_effect("move_origin", position)


func end_game():
	game_ongoing = false
	emit_signal("game_ended", current_turn)
