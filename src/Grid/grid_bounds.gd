# An abstract class for determining if a point is contained within a grid
class_name GridBounds


# The size of the grid in each dimension
var dimensions


func _init(dimensions):
	self.dimensions = dimensions


# Returns whether the given position is within the grid
func is_in_bounds(position) -> bool:
	return false
