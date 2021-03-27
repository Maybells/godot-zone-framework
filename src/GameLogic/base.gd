signal game_reset
signal game_initialized
signal piece_moved(piece, to)


# Returns true if the game logic allows piece to go from start to end
func is_move_valid(piece, start, end):
	return false

# Moves piece to the given zone
func move_piece(piece, to):
	piece.origin_zone = to
	to.piece_added(piece)
	emit_signal("piece_moved", piece, to)