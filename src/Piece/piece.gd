extends Node2D

class_name Piece


var zone: Zone
var id: int
var game: GameLogic


func return_to_origin():
	zone.reset_piece_position(self)


func warp_to_position(position):
	pass


func move_to_position(position):
	pass
