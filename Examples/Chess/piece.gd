extends DragPiece2D


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
var first_move = true
var pawn_diag_left = false
var pawn_diag_right = false
var captured = false


func _ready():
	$DragMovement2D.connect("picked_up", self, "_on_picked_up")
	$DragMovement2D.connect("put_down", self, "_on_put_down")
	
	_load_icon()
	if type == ChessLogic.KING:
		game.connect("king_checked", self, "_king_checked")
		game.connect("king_not_checked", self, "_king_not_checked")


func _load_icon():
	var icon = ""
	if is_white:
		icon += "white"
	else:
		icon += "black"
	
	icon += "_"
	icon += PIECE_MAP[type]
	$Sprite.texture = load("res://Examples/Chess/Images/" + icon + ".png")


func _on_picked_up():
	if not captured:
		z_index += 1
		game.piece_picked_up(self)
	else:
		$DragMovement2D.release()


func _on_put_down():
	if game.is_move_valid(self, zone, overlap_zone):
		if zone != overlap_zone:
			first_move = false
		z_index -= 1
		game.move_piece(self, overlap_zone)
		game.piece_put_down(self)
	else:
		$DragMovement2D.attach()


func _king_checked(color):
	if color == is_white:
		$Sprite.material = load("res://Examples/Chess/Materials/outline.tres")


func _king_not_checked(color):
	if color == is_white:
		$Sprite.material = null


func captured():
	if type == ChessLogic.KING:
		game.end_game()
	
	captured = true
	game.unregister_piece(self)
	zone.piece_removed(self)
	queue_free()
