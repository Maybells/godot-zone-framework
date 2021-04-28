extends DragPiece2D


const PIECE_MAP = {
	ChessLogic.PAWN: "pawn",
	ChessLogic.QUEEN: "queen",
	ChessLogic.KING: "king",
	ChessLogic.ROOK: "rook",
	ChessLogic.BISHOP: "bishop",
	ChessLogic.KNIGHT: "knight"
}


var pawn_up = SquareMovePattern.new("U")
var pawn_up_start = SquareMovePattern.new("U", SquareMovePattern.NONE, 2)
var pawn_up_capture = SquareMovePattern.new("(RU)", SquareMovePattern.MIRROR_X)
var pawn_down = SquareMovePattern.new("D")
var pawn_down_start = SquareMovePattern.new("D", SquareMovePattern.NONE, 2)
var pawn_down_capture = SquareMovePattern.new("(RD)", SquareMovePattern.MIRROR_X)
var bishop = SquareMovePattern.new("(RU)", SquareMovePattern.ROTATE_FULL, -1)
var rook = SquareMovePattern.new("R", SquareMovePattern.ROTATE_FULL, -1)
var knight = SquareMovePattern.new("2RU", SquareMovePattern.ROTATE_MIRROR)
var short_diag = SquareMovePattern.new("(RU)", SquareMovePattern.ROTATE_FULL)
var short_orthog = SquareMovePattern.new("R", SquareMovePattern.ROTATE_FULL)


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
	z_index += 1
	game.piece_picked_up(self)


func _on_put_down():
	if game.is_move_valid(self, zone, overlap_zone):
		if zone != overlap_zone:
			first_move = false
		z_index -= 1
		game.move_piece(self, overlap_zone)
		game.piece_put_down(self)
		$DragMovement2D.release()


func _king_checked(color):
	if color == is_white:
		$Sprite.material = load("res://Examples/Chess/Materials/outline.tres")


func _king_not_checked(color):
	if color == is_white:
		$Sprite.material = null


func _get_pawn_pattern():
	if is_white:
		if first_move:
			return [pawn_up_start, pawn_up_capture]
		else:
			return [pawn_up, pawn_up_capture]
	else:
		if first_move:
			return [pawn_down_start, pawn_down_capture]
		else:
			return [pawn_down, pawn_down_capture]


func get_move_patterns():
	match type:
		ChessLogic.PAWN:
			return _get_pawn_pattern()
		ChessLogic.KING:
			return [short_orthog, short_diag]
		ChessLogic.QUEEN:
			return [rook, bishop]
		ChessLogic.KNIGHT:
			return [knight]
		ChessLogic.BISHOP:
			return [bishop]
		ChessLogic.ROOK:
			return [rook]


func captured():
	if type == ChessLogic.KING:
		game.end_game()
	
	captured = true
	game.unregister_piece(self)
	zone.piece_removed(self)
	queue_free()
