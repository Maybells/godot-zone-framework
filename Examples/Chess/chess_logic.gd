extends "res://src/GameLogic/base.gd"

class_name ChessLogic


var grid = GridUtility.new(Vector2(8, 8))
var bishop = MovePattern.new("RU", MovePattern.ROTATE, -1)
var rook = MovePattern.new("R", MovePattern.ROTATE, -1)
var knight = MovePattern.new("2RU", MovePattern.ROTATE_MIRROR)


func is_move_valid(piece, start, end):
	if end:
		if start:
			var position = grid.convert_1d_to_2d(start.id)
			var possible = grid.get_pattern_results(position, bishop)
			var aim = grid.convert_1d_to_2d(end.id)
			if aim in possible:
				return true
			return false
		else:
			return true
	else:
		return false

func move_piece(piece, to):
	if to == piece.origin_zone:
		to.piece_added(piece)
		emit_signal("piece_moved", piece, to)
	else:
		piece.origin_zone = to
		to.piece_added(piece)
		emit_signal("piece_moved", piece, to)