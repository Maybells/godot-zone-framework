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


# Returns an array of all possible and impossible moves a piece can take.
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


# Highlights all tiles that a given piece can be placed.
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


func piece_picked_up(piece):
	_highlight_moves(piece)


func piece_put_down(piece):
	reset_effect("move_possibilities")
	reset_effect("move_origin")
	update_effect("move_possibilities")
	update_effect("move_origin")


func end_game():
	game_ongoing = false
	emit_signal("game_ended", current_turn)
