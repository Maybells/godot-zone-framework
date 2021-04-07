extends Area2D


var id
var game

var pieces = Array()


func _ready():
	pass


func can_accept_piece(piece):
	return true


func reset_piece_position(piece):
	pass


func piece_added(piece, location = null):
	piece.origin_zone = self
	pieces.append(piece)


func piece_removed(piece):
	pieces.erase(piece)
