# A node representing a game piece, such as a chess piece or an inventory item
class_name Piece2D
extends Node2D


# A unique identifier associated with each piece.
# The identifier is not constrained to a specific data type, so `1234`, `(12, 2)`, and `"black_queen"` are all valid ids.
var id
# The GameLogic associated with this piece
var game
# The Zone that currently contains this piece
var zone


# Moves the piece to a default location specified by its Zone
func return_to_zone():
	zone.reset_piece_position(self)


# Teleports the piece to the given position.
func warp_to_position(position: Vector2):
	self.position = position


# Moves the piece to the given position. Unless overriden, an alias of `warp_to_position`.
func move_to_position(position: Vector2):
	warp_to_position(position)
