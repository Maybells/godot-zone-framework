class_name MovePattern


# NONE will not mirror or rotate moves
# MIRROR_X mirrors across the y axis
# MIRROR_Y mirrors across the x axis
# MIRROR_XY mirrors across the x and y axes
# ROTATE mirrors radially
# ROTATE_MIRROR mirrors radially and across the radius
enum {NONE, MIRROR_X, MIRROR_Y, MIRROR_XY, ROTATE, ROTATE_MIRROR}


var moves
var repeat
var mode


func _init(moves, mode = NONE, repeat = 0):
	self.moves = _generate_moves(moves)
	self.repeat = repeat
	self.mode = mode


func _generate_moves(string):
	return SquareMoveSequence.new(string)