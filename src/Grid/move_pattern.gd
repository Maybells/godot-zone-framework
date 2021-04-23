# A resource describing a set of potential movements
class_name MovePattern


# <-- Modes -->
# Will not mirror or rotate moves
const NONE = 0


# The base moves of the sequence
var moves: String
# How many times the pattern can repeat. If repeat is -1, will repeat until stopped.
var repeat: int
# Any additional operations that will be applied to the pattern
var mode: int


func _init(moves: String, mode: int = NONE, repeat: int = 0):
	self.moves = moves
	self.repeat = repeat
	self.mode = mode
