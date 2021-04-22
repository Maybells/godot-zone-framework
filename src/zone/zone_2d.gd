# A node representing a game location, such as a tile or inventory slot
class_name Zone2D
extends Node2D


var id
var game: GameLogic
var pieces = Array()


func _ready():
	pass


func can_accept_piece(piece: Piece2D):
	return true


func reset_piece_position(piece: Piece2D):
	pass


func piece_added(piece: Piece2D):
	piece.zone = self
	pieces.append(piece)


func piece_removed(piece: Piece2D):
	pieces.erase(piece)
