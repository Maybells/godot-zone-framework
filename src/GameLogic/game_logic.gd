class_name GameLogic


signal game_reset
signal game_initialized
signal piece_moved(piece, to)
signal piece_focused
signal piece_unfocused


var pieces = Array()
var zones = Array()

var focused_pieces = Array()
var just_unfocused = false


func register_piece(piece):
	piece.game = self
	pieces.append(piece)


func register_zone(zone):
	zone.game = self
	zones.append(zone)


func unregister_piece(piece):
	if is_focused(piece):
		unfocus_piece(piece)
	piece.game = null
	pieces.erase(piece)


func unregister_zone(zone):
	zone.game = null
	zones.erase(zone)


func tick():
	just_unfocused = false


# Returns true if the game logic allows piece to go from start to end
func is_move_valid(piece, start, end):
	return (end != null) and (end.can_accept_piece(piece))


# Moves piece to the given zone
func move_piece(piece, to):
	piece.zone.piece_removed(piece)
	piece.zone = to
	to.piece_added(piece)
	emit_signal("piece_moved", piece, to)


func has_focus():
	return not focused_pieces.empty()


func is_focused(piece):
	return piece in focused_pieces


func just_unfocused():
	return just_unfocused


func can_focus(piece):
	return true


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
