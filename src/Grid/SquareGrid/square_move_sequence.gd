extends MoveSequence

class_name SquareMoveSequence


const LEFT = Vector2.LEFT
const RIGHT = Vector2.RIGHT
const UP = Vector2.UP
const DOWN = Vector2.DOWN


var _repeat


func _init(moves = "").(moves):
	pass


func _sequence_from_string(string):
	_repeat = 0
	string = string.to_upper()
	var seq = PoolVector2Array()
	for ch in string:
		if ch.is_valid_integer():
			_repeat *= 10
			_repeat += int(ch)
		elif _repeat == 0:
			seq.append(_direction_from_char(ch))
		else:
			for i in range(_repeat):
				seq.append(_direction_from_char(ch))
			_repeat = 0
	return seq


func _direction_from_char(ch):
	match ch:
		"L":
			return LEFT
		"R":
			return RIGHT
		"U":
			return UP
		"D":
			return DOWN


# Returns a sequence with all move A's replaced with B's and vice versa
func _switch_moves(a, b):
	var replacement = Array()
	for move in sequence:
		if move == a:
			replacement.append(b)
		elif move == b:
			replacement.append(a)
		else:
			replacement.append(move)
	return replacement


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
	return _switch_moves(LEFT, RIGHT)


# Returns sequence mirrored across the x-axis
func get_mirror_y():
	return _switch_moves(UP, DOWN)