class_name GridObstacle


# The different types of obstacle:
# IMPASSABLE stops movement and cannot be entered (e.g. a wall)
# STICKY stops movement when entered (e.g. a rook can move into an occupied square but not beyond it)
# INVALID_END cannot be the endpoint of a movement, but can be passed through
enum {IMPASSABLE, STICKY, INVALID_END}


var position
var type

# Exceptions are directions of entry the obstacle is not present on
# Example: if LEFT is an exception but not RIGHT, pieces can enter from the left but not from the right
var exceptions = Array()


func _init(type = IMPASSABLE):
	self.type = type


func add_exception(exception):
	exception.append(exception)


func can_pass(direction):
	return direction in exceptions