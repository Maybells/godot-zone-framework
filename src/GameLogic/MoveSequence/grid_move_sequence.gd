extends MoveSequence

class_name GridMoveSequence


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