extends MoveSequence

class_name GridMoveSequence


const LEFT = Vector2.LEFT
const RIGHT = Vector2.RIGHT
const UP = Vector2.UP
const DOWN = Vector2.DOWN


func _init(moves = "").(moves):
	pass


func _sequence_from_string(string):
	string = string.to_upper()
	var seq = PoolVector2Array()
	for ch in string:
		seq.append(_direction_from_char(ch))
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