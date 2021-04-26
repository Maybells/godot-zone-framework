# A resource describing a set of potential movements
class_name MovePattern


# <-- Modes -->
# Will not mirror or rotate moves
const NONE = 0


# <-- Directions -->
const NO_DIRECTION = 0


# The base moves of the sequence
var moves: String
# How many times in a row the pattern can happen. If repeat is -1, will repeat until stopped.
var repeat: int
# Any additional operations that will be applied to the pattern
var mode: int
# The base moves of the pattern
var sequence = Array()


func _init(moves: String, mode: int = NONE, repeat: int = 1):
	self.moves = moves
	self.repeat = repeat
	self.mode = mode
	
	sequence = _sequence_from_string(moves)


func _sequence_from_string(string: String) -> Array:
	var out = Array()
	string = string.to_upper()
	var repeat = 0
	var buffer = ""
	var buffer_active = false
	for i in range(len(string)):
		var ch = string[i]
		if buffer_active:
			if ch == ")":
				out += _handle_token(buffer, repeat)
				repeat = 0
				buffer = ""
				buffer_active = false
			else:
				buffer += ch
		else:
			if ch == "(":
				buffer_active = true
			elif ch.is_valid_integer():
				repeat *= 10
				repeat += int(ch)
			else:
				out += _handle_token(ch, repeat)
				repeat = 0
	return out


func _handle_token(token: String, repeat: int) -> Array:
	if repeat == 0:
		repeat = 1
	var out = Array()
	var direction = _direction_from_token(token)
	for i in range(repeat):
		out.append(direction)
	return out


func _direction_from_token(token):
	pass


# Returns a sequence with all move A's replaced with B's and vice versa
func _switch_moves(moves, a, b):
	var replacement = Array()
	for move in moves:
		if move == a:
			replacement.append(b)
		elif move == b:
			replacement.append(a)
		else:
			replacement.append(move)
	return replacement
