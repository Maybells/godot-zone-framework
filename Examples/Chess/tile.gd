extends "res://src/Zone/zone.gd"

var white = Color(111/255.0, 143/255.0, 114/255.0)
var black = Color(173/255.0, 189/255.0, 143/255.0)
var highlighted = Color(1, 1, 1, 0.75)
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
	draw_rect(rect, color)
	if game.is_valid_endpoint(self):
		draw_rect(rect, highlighted)


func can_accept_piece(piece):
	if pieces.empty():
		return true
	var p = pieces[0]
	if p and p.is_white != piece.is_white:
		return true
	return piece.origin_zone == self


func reset_piece_position(piece):
	piece.position = position


func piece_added(piece, location = null):
	for p in pieces:
		p.captured()
	.piece_added(piece, location)
	piece.position = position


func piece_removed(piece):
	.piece_removed(piece)


func _on_piece_focus():
	update()