# A representation of an obstacle at a position in a grid
class_name GridObstacle


# The different types of obstacle:
# IMPASSABLE stops movement and cannot be entered (e.g. a wall)
# STICKY stops movement when entered (e.g. a rook can move into an occupied square but not beyond it)
# INVALID_END cannot be the endpoint of a movement, but can be passed through
enum {IMPASSABLE, STICKY, INVALID_END}


# The position of the obstacle in the grid
var position
# What kind of obstacle it is
var type
# Exceptions are directions of entry the obstacle is not present on
# Example: if LEFT is an exception but not RIGHT, pieces can enter from the left but not from the right
var exceptions = Array()


func _init(type = IMPASSABLE):
	self.type = type


# Adds a direction from which the obstacle does not apply.
func add_exception(exception):
	exception.append(exception)


# Returns whether the obstacle can be entered from the given direction.
func can_enter(direction) -> bool:
	return direction in exceptions
