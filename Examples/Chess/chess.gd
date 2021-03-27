extends Node2D


onready var tile = preload("res://Examples/Chess/tile.tscn")
onready var piece = preload("res://Examples/Chess/piece.tscn")
onready var game = ChessLogic.new()


# Generates the grid of chess tiles
func _ready():
	var p = piece.instance()
	p.game = game
	p.position = Vector2(190, 350)
	add_child(p)
	
	var index = 0
	for point in $Grid.points:
		var t = tile.instance()
		t.id = index
		t.position = $Grid.position + point
		var rank = index % 8
		var file = index / 8
		t.is_white = (rank + file) % 2 == 0
		add_child(t)
		
		index += 1