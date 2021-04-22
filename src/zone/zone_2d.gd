# A node representing a game location, such as a tile or inventory slot
class_name Zone2D
extends Node2D


# A unique identifier associated with each piece.
# The identifier is not constrained to a specific data type, so `1234`, `(12, 2)`, and `"black_queen"` are all valid ids.
var id
# The GameLogic node associated with this zone
var game
# An array of pieces that this zone contains
var pieces = Array()


# Returns whether the zone can accept the given piece.
func can_accept_piece(piece) -> bool:
	return true


# Moves the given piece to a default position
func reset_piece_position(piece) -> void:
	pass


# Accepts the given piece
func piece_added(piece):
	piece.zone = self
	pieces.append(piece)


# Removes the given piece
func piece_removed(piece):
	pieces.erase(piece)
