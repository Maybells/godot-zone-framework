class_name MoveSequence


var sequence = Array()


func _init(moves = ""):
	sequence = _sequence_from_string(moves)


func _sequence_from_string(string):
	sequence = Array()


func push(move):
	sequence.append(move)


func peek():
	return sequence[0]


func pop():
	return sequence.pop_front()


func move_at(index):
	return sequence[index]


func add(index, move):
	sequence.insert(index, move)

