extends "res://src/Piece/piece.gd"


export (Color) var white = Color(204, 183, 174)
export (Color) var black = Color(112, 102, 119)


var is_white = true
var color
var holding = false


func _ready():
	$ZoneDetector.add_exception($ClickArea)
	
	$ClickArea.connect("input_event", self, "_on_input_event")
	if is_white:
		color = white
	else:
		color = black


func _process(delta):
	if holding:
		position = get_viewport().get_mouse_position()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if not holding and not game.has_focus() and not game.just_unfocused():
				_pick_up()
			elif game.is_focused(self):
				_put_down()


func _pick_up():
	if not game.has_focus():
		z_index += 1
		game.focus_piece(self)
		holding = true


func _put_down():
	z_index -= 1
	game.unfocus_piece(self)
	if game.is_move_valid(self, origin_zone, overlap_zone):
		holding = false
		game.move_piece(self, overlap_zone)
	else:
		holding = false
		if origin_zone:
			game.move_piece(self, origin_zone)
