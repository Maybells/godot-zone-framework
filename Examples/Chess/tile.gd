extends Zone2D

const WHITE = Color(111/255.0, 143/255.0, 114/255.0)
const BLACK = Color(173/255.0, 189/255.0, 143/255.0)
const HIGHLIGHT = Color(1, 1, 1, 0.9)
const ORIGIN = Color(0.2, 0.4, 1, 0.4)


var location
var is_white = true
var color


func _ready():
	if is_white:
		$Base.color = WHITE
	else:
		$Base.color = BLACK
	
	$Highlight.color = HIGHLIGHT
	$Origin.color = ORIGIN
	
	game.connect_to_effect("move_possibilities", self, "_on_move_possibilities_changed")
	game.connect_to_effect("move_origin", self, "_on_move_origin_changed")


func can_accept_piece(piece):
	if pieces.empty():
		return true
	var p = pieces[0]
	if p and p.is_white != piece.is_white:
		return true
	return piece.zone == self


func reset_piece_position(piece):
	piece.position = position


func piece_added(piece):
	for p in pieces:
		p.captured()
	.piece_added(piece)
	piece.position = position


func piece_removed(piece):
	.piece_removed(piece)


func _on_move_possibilities_changed():
	$Highlight.visible = game.has_effect("move_possibilities", location)


func _on_move_origin_changed():
	$Origin.visible = game.has_effect("move_origin", location)
