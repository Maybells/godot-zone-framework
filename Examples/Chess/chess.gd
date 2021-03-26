extends Node2D


onready var tile = preload("res://Examples/Chess/tile.tscn")


# Generates the grid of chess tiles
func _ready():
	var index = 0
	for point in $Grid.points:
		var t = tile.instance()
		t.position = $Grid.position + point
		var rank = index % 8
		var file = index / 8
		t.is_white = (rank + file) % 2 == 0
		add_child(t)
		
		index += 1