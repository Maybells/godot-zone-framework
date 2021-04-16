extends Node2D

class_name Piece2D


var zone: Zone
var id: int
var game: GameLogic


func return_to_origin():
	zone.reset_piece_position(self)


func warp_to_position(position: Vector2):
	self.position = position


func move_to_position(position: Vector2):
	pass
