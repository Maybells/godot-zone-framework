extends "res://src/GameLogic/base.gd"

class_name ChessLogic


enum {QUEEN, KING, PAWN, KNIGHT, ROOK, BISHOP}


var grid = GridUtility.new(Vector2(8, 8))
var pawn_up = MovePattern.new("U")
var pawn_down = MovePattern.new("D")
var bishop = MovePattern.new("RU", MovePattern.ROTATE, -1)
var rook = MovePattern.new("R", MovePattern.ROTATE, -1)
var knight = MovePattern.new("2RU", MovePattern.ROTATE_MIRROR)
var short_diag = MovePattern.new("RU", MovePattern.ROTATE)
var short_orthog = MovePattern.new("R", MovePattern.ROTATE)

var move_possibilies = PoolVector2Array()


func _get_possibilities(piece):
	var position = grid.convert_1d_to_2d(piece.origin_zone.id)
	match piece.type:
		PAWN:
			if piece.is_white:
				return grid.get_pattern_results(position, pawn_up)
			else:
				return grid.get_pattern_results(position, pawn_down)
		KNIGHT:
			return grid.get_pattern_results(position, knight)
		ROOK:
			return grid.get_pattern_results(position, rook)
		BISHOP:
			return grid.get_pattern_results(position, bishop)
		KING:
			return grid.get_pattern_results(position, short_diag) + grid.get_pattern_results(position, short_orthog)
		QUEEN:
			return grid.get_pattern_results(position, bishop) + grid.get_pattern_results(position, rook)


func is_move_valid(piece, start, end):
	if end:
		if start:
			var possible = _get_possibilities(piece)
			var aim = grid.convert_1d_to_2d(end.id)
			if aim in possible and end.can_accept_piece(piece):
				return true
			return false
		else:
			return true
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
	var position = grid.convert_1d_to_2d(zone.id)
	return position in move_possibilies



