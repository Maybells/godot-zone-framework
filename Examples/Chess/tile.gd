extends "res://src/Zone/zone.gd"

export (Color) var white = Color(204, 183, 174)
export (Color) var black = Color(112, 102, 119)
var is_white = true
var color


func _ready():
	if is_white:
		color = white
	else:
		color = black


func _draw():
	draw_rect(Rect2($Corner.position, Vector2(64, 64)), color)


func piece_added(piece, location = null):
	piece.position = position