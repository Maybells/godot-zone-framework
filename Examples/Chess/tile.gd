extends "res://src/Zone/zone.gd"

export (Color) var white = Color.beige
export (Color) var black = Color.burlywood
export (Color) var highlighted = Color.aliceblue
var is_white = true
var color


func _ready():
	game.connect("piece_focused", self, "_on_piece_focus")
	game.connect("piece_unfocused", self, "_on_piece_focus")
	
	if is_white:
		color = white
	else:
		color = black


func _draw():
	var rect = Rect2($Corner.position, Vector2(64, 64))
	if game.is_valid_endpoint(self):
		draw_rect(rect, highlighted)
	else:
		draw_rect(rect, color)


func can_accept_piece(piece):
	if pieces.empty():
		return true
	var p = pieces[0]
	if p and p.is_white != piece.is_white:
		return true
	return piece.origin_zone == self


func piece_added(piece, location = null):
	for p in pieces:
		p.captured()
	.piece_added(piece, location)
	piece.position = position


func piece_removed(piece):
	.piece_removed(piece)


func _on_piece_focus():
	update()