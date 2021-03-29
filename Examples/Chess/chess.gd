extends Node2D


const BACK_ROW = [ChessLogic.ROOK, ChessLogic.KNIGHT, ChessLogic.BISHOP, ChessLogic.KING, ChessLogic.QUEEN, ChessLogic.BISHOP, ChessLogic.KNIGHT, ChessLogic.ROOK]


onready var tile = preload("res://Examples/Chess/tile.tscn")
onready var piece = preload("res://Examples/Chess/piece.tscn")
onready var game = ChessLogic.new()


# Generates the grid of chess tiles
func _ready():
	var index = 0
	for point in $Grid.points:
		var t = tile.instance()
		t.id = index
		game.register_zone(t)
		t.position = $Grid.position + point
		var rank = index % 8
		var file = index / 8
		t.is_white = (rank + file) % 2 == 0
		add_child(t)
		
		if file <= 1 or file >= 6:
			var p = _generate_piece_at(rank, file)
			t.piece_added(p)
			add_child(p)
		
		index += 1


func _process(delta):
	game.tick()


func _generate_piece_at(rank, file):
	var p = piece.instance()
	game.register_piece(p)
	
	if file <= 1:
		p.is_white = false
	elif file >= 6:
		p.is_white = true
	
	if file == 1 or file == 6:
		p.type = ChessLogic.PAWN
	elif file == 0 or file == 7:
		p.type = BACK_ROW[rank]
	
	return p





