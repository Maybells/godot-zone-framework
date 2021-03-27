extends "res://src/GameLogic/base.gd"

class_name ChessLogic


var grid = GridUtility.new(Vector2(8, 8))
var bishop = MovePattern.new("RU", MovePattern.ROTATE, -1)
var rook = MovePattern.new("R", MovePattern.ROTATE, -1)
var knight = MovePattern.new("2RU", MovePattern.ROTATE_MIRROR)

var move_possibilies = PoolVector2Array()


func is_move_valid(piece, start, end):
	if end:
		if start:
			var position = grid.convert_1d_to_2d(start.id)
			var possible = grid.get_pattern_results(position, bishop)
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
	var position = grid.convert_1d_to_2d(piece.origin_zone.id)
	move_possibilies = grid.get_pattern_results(position, bishop)
	.focus_piece(piece)


func unfocus_piece(piece):
	move_possibilies = PoolVector2Array()
	.unfocus_piece(piece)


func is_valid_endpoint(zone):
	var position = grid.convert_1d_to_2d(zone.id)
	return position in move_possibilies



