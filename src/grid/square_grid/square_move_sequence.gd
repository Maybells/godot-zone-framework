class_name SquareMoveSequence
extends MoveSequence


const LEFT = Vector2.LEFT
const RIGHT = Vector2.RIGHT
const UP = Vector2.UP
const DOWN = Vector2.DOWN
const DIAG_UR = UP + RIGHT
const DIAG_DR = DOWN + RIGHT
const DIAG_UL = UP + LEFT
const DIAG_DL = DOWN + LEFT


func _init(moves = "").(moves):
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
		if move == LEFT:
			replacement.append(UP)
		elif move == RIGHT:
			replacement.append(DOWN)
		elif move == UP:
			replacement.append(RIGHT)
		elif move == DOWN:
			replacement.append(LEFT)
		elif move == DIAG_DL:
			replacement.append(DIAG_UL)
		elif move == DIAG_DR:
			replacement.append(DIAG_DL)
		elif move == DIAG_UL:
			replacement.append(DIAG_UR)
		elif move == DIAG_UR:
			replacement.append(DIAG_DR)
	return replacement


# Returns sequence rotated clockwise n times
func get_rotation(rotations = 1):
	rotations = rotations % 4
	var last_moves = sequence
	for i in range(rotations):
		last_moves = _rotate_clockwise(last_moves)
	
	return last_moves


# Returns sequence mirrored across the y-axis
func get_mirror_x():
	var mirror = _switch_moves(sequence, LEFT, RIGHT)
	mirror = _switch_moves(mirror, DIAG_UL, DIAG_UR)
	mirror = _switch_moves(mirror, DIAG_DL, DIAG_DR)
	return mirror


# Returns sequence mirrored across the x-axis
func get_mirror_y():
	var mirror = _switch_moves(sequence, UP, DOWN)
	mirror = _switch_moves(mirror, DIAG_UL, DIAG_DL)
	mirror = _switch_moves(mirror, DIAG_UR, DIAG_DR)
	return mirror
