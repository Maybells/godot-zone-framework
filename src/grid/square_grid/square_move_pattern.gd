# A resource describing a set of potential movements on a grid of squares
class_name SquareMovePattern
extends MovePattern


# <-- Modes -->
# Mirrors the moves across the y-axis
const MIRROR_X = 1
# Mirrors the moves across the x-axis
const MIRROR_Y = 2
# Mirrors the moves across the x and y-axes
const MIRROR_XY = 3
# Rotates the moves for each direction
const ROTATE = 4
# Rotates the moves for each direction and mirrors them across that direction's axis
const ROTATE_MIRROR = 5


func _init(moves, mode = NONE, repeat = 0).(moves, mode, repeat):
	pass
