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
# Mirrors the moves across the xy-axis, but not across the x or y-axes individually
const MIRROR_DIAGONAL = 4
# Rotates the moves once
const ROTATE_HALF = 5
# Rotates the moves once for each direction
const ROTATE_FULL = 6
# Rotates the moves once for each direction and mirrors them across that direction's axis
const ROTATE_MIRROR = 7


# <-- Directions -->
const LEFT = Vector2.LEFT
const RIGHT = Vector2.RIGHT
const UP = Vector2.UP
const DOWN = Vector2.DOWN
const DIAG_UR = UP + RIGHT
const DIAG_DR = DOWN + RIGHT
const DIAG_UL = UP + LEFT
const DIAG_DL = DOWN + LEFT


const CLOCKWISE = {
	LEFT: UP,
	RIGHT: DOWN,
	UP: RIGHT,
	DOWN: LEFT,
	DIAG_DL: DIAG_UL,
	DIAG_DR: DIAG_DL,
	DIAG_UL: DIAG_UR,
	DIAG_UR: DIAG_DR,
}


func _init(moves, mode = NONE, repeat = 1).(moves, mode, repeat):
	pass


func _direction_from_token(token):
	match token:
		"L":
			return LEFT
		"R":
			return RIGHT
		"U":
			return UP
		"D":
			return DOWN
		"DL":
			continue
		"LD":
			return DIAG_DL
		"UL":
			continue
		"LU":
			return DIAG_UL
		"DR":
			continue
		"RD":
			return DIAG_DR
		"UR":
			continue
		"RU":
			return DIAG_UR


# Returns sequence rotatated 90 degrees clockwise
func _rotate_clockwise(moves = sequence):
	var replacement = PoolVector2Array()
	for move in moves:
		replacement.append(CLOCKWISE[move])
	return replacement


# Returns sequence rotated clockwise n times
func get_rotation(rotations = 1):
	rotations = rotations % 4
	var last_moves = sequence
	for i in range(rotations):
		last_moves = _rotate_clockwise(last_moves)
	
	return last_moves


func get_mirror_rotation(rotations = 1):
	var mirror = get_rotation(rotations)
	mirror = get_mirror_x(mirror)
	return mirror


# Returns a sequence mirrored across the y-axis
func get_mirror_x(sequence = self.sequence):
	var mirror = _switch_moves(sequence, LEFT, RIGHT)
	mirror = _switch_moves(mirror, DIAG_UL, DIAG_UR)
	mirror = _switch_moves(mirror, DIAG_DL, DIAG_DR)
	return mirror


# Returns a sequence mirrored across the x-axis
func get_mirror_y(sequence = self.sequence):
	var mirror = _switch_moves(sequence, UP, DOWN)
	mirror = _switch_moves(mirror, DIAG_UL, DIAG_DL)
	mirror = _switch_moves(mirror, DIAG_UR, DIAG_DR)
	return mirror


func get_mirror_diagonal(sequence = self.sequence):
	var mirror = get_mirror_x(sequence)
	mirror = get_mirror_y(mirror)
	return mirror
