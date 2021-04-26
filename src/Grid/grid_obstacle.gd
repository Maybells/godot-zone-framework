# A representation of an obstacle at a position in a grid
class_name GridObstacle


# The different types of obstacle:
# IMPASSABLE stops movement and cannot be entered (e.g. a wall)
# STICKY stops movement when entered (e.g. a rook can move into an occupied square but not beyond it)
# INVALID_END cannot be the endpoint of a movement, but can be passed through
enum {BLOCK, STICKY, PUSH, REPEAT, TELEPORT, INVALID_END}


# The position of the obstacle in the grid
var position
# What kind of obstacle it is
var type
# Extra parameters, depending on the type of obstacle
var params := {}
# Whether the obstacle takes effect when something enters its position
var apply_on_enter := true
# Whether the obstacle takes effect when something leaves its position
var apply_on_exit := true
# Whether the obstacle takes effect when something starts at or teleports to its position
var apply_on_start := true
# Exceptions are directions of entry the obstacle is not present on
# Example: if LEFT is an exception but not RIGHT, pieces can enter from the left but not from the right
var exceptions = Array()


func _init(position, type = BLOCK, params = {}):
	self.position = position
	self.type = type
	self.params = params


# Adds a direction from which the obstacle does not apply.
func add_exception(exception):
	exception.append(exception)


# Returns whether the obstacle can be entered from the given direction.
func covers(direction) -> bool:
	return not direction in exceptions


# Returns the parameter with the given name, if it exists. Otherwise returns null.
func get_param(name: String):
	if name in params:
		return params[name]
	return null
