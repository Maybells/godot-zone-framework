extends "res://src/Piece/piece.gd"


const PIECE_MAP = {
	ChessLogic.PAWN: "pawn",
	ChessLogic.QUEEN: "queen",
	ChessLogic.KING: "king",
	ChessLogic.ROOK: "rook",
	ChessLogic.BISHOP: "bishop",
	ChessLogic.KNIGHT: "knight"
}


var white = Color.white
var black = Color.black


var is_white = true
var type
var color
var holding = false
var first_move = true
var pawn_diag_left = false
var pawn_diag_right = false
var captured = false


func _ready():
	$ZoneDetector.add_exception($ClickArea)
	
	$ClickArea.connect("input_event", self, "_on_input_event")
	_load_icon()
	if type == ChessLogic.KING:
		game.connect("king_checked", self, "_king_checked")
		game.connect("king_not_checked", self, "_king_not_checked")


func _process(delta):
	if holding:
		position = get_viewport().get_mouse_position()


func _on_input_event(viewport, event, shape_idx):
	if not captured:
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
	if not game.has_focus() and game.can_focus(self):
		z_index += 1
		game.focus_piece(self)
		holding = true


func _put_down():
	if game.is_move_valid(self, origin_zone, overlap_zone):
		if origin_zone != overlap_zone:
			first_move = false
		z_index -= 1
		game.unfocus_piece(self)
		holding = false
		game.move_piece(self, overlap_zone)
	else:
		pass
#		holding = false
#		if origin_zone:
#			game.move_piece(self, origin_zone)


func _king_checked(color):
	if color == is_white:
		$Sprite.material = load("res://Examples/Chess/Materials/outline.tres")


func _king_not_checked(color):
	if color == is_white:
		$Sprite.material = null


func captured():
	captured = true
	game.unregister_piece(self)
	origin_zone.piece_removed(self)
	queue_free()
