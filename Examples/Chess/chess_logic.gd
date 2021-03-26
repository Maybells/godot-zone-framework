extends "res://src/GameLogic/base.gd"


func _ready():
	pass


func is_move_valid(piece, start, end):
	if end:
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