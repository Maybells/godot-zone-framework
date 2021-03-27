signal game_reset
signal game_initialized
signal piece_moved(piece, to)
signal piece_focused
signal piece_unfocused


var focused_pieces = Array()
var just_unfocused = false


func tick():
	just_unfocused = false


# Returns true if the game logic allows piece to go from start to end
func is_move_valid(piece, start, end):
	return false


# Moves piece to the given zone
func move_piece(piece, to):
	piece.origin_zone.piece_removed(piece)
	piece.origin_zone = to
	to.piece_added(piece)
	emit_signal("piece_moved", piece, to)


func has_focus():
	return not focused_pieces.empty()


func is_focused(piece):
	return piece in focused_pieces


func just_unfocused():
	return just_unfocused


func focus_piece(piece):
	focused_pieces.append(piece)
	emit_signal("piece_focused")


func unfocus_piece(piece):
	just_unfocused = true
	focused_pieces.erase(piece)
	emit_signal("piece_unfocused")


func unfocus_all():
	just_unfocused = true
	focused_pieces = Array()
	emit_signal("piece_unfocused")