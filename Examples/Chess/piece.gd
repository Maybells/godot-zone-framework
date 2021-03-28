extends "res://src/Piece/piece.gd"


const PIECE_MAP = {
	ChessLogic.PAWN: "pawn",
	ChessLogic.QUEEN: "queen",
	ChessLogic.KING: "king",
	ChessLogic.ROOK: "rook",
	ChessLogic.BISHOP: "bishop",
	ChessLogic.KNIGHT: "knight"
}


export (Color) var white = Color.white
export (Color) var black = Color.black


var is_white = true
var type
var color
var holding = false


func _ready():
	$ZoneDetector.add_exception($ClickArea)
	
	$ClickArea.connect("input_event", self, "_on_input_event")
	_load_icon()


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


func _load_icon():
	var icon = ""
	if is_white:
		icon += "white"
	else:
		icon += "black"
	
	icon += "_"
	icon += PIECE_MAP[type]
	$Sprite.texture = load("res://Examples/Chess/Images/" + icon + ".png")


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
