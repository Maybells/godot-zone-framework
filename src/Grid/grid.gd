# An abstract class for handling grid-based movement and connections
class_name Grid


# The outer boundaries of the grid
var boundaries: GridBounds

# The obstacles currently on the grid
var _obstacles


func _init(boundaries: GridBounds):
	self.boundaries = boundaries


# Returns an array of all obstacles at the given position.
func _obstacles_at(position) -> Array:
	var out := []
	for obstacle in _obstacles:
		if obstacle.position == position:
			out.append(obstacle)
	return out


# Takes a MovePattern and returns an array of paths described by the pattern.
func _pattern_to_paths(pattern):
	pass


# Returns the opposite of the given direction.
func _invert_direction(direction):
	pass


# Creates a new MovePath with values equal to the given MovePath.
func _duplicate_path(path: MovePath) -> MovePath:
	var duplicate = MovePath.new(path.instructions)
	duplicate.path = path.path.duplicate()
	duplicate.failed = path.failed
	duplicate.finished = path.finished
	duplicate.interactions = path.interactions.duplicate()
	return duplicate


# Alters the path based on the type and parameters of the given obstacle.
func _handle_obstacle(path: MovePath, obstacle: GridObstacle):
	path.add_interaction(obstacle)
	match obstacle.type:
		GridObstacle.BLOCK:
			path.failed = true
		GridObstacle.STICKY:
			path.finished = true
			path.can_continue = false
		_:
			pass


# Interacts with all obstacles at a position who can interact.
func _handle_obstacles_at(position, path: MovePath, direction, can_interact := "apply_on_enter"):
	var obs := _obstacles_at(position)
	for obstacle in obs:
		if obstacle.get(can_interact) and obstacle.covers(direction):
			_handle_obstacle(path, obstacle)


# Applies obstacle effects at the end of a path.
func _handle_end_obstacles(position, path: MovePath):
	var obs := _obstacles_at(position)
	for obstacle in obs:
		if obstacle.type == GridObstacle.INVALID_END:
			path.failed = true


# Attempts to add a new position to the path.
func _enter_position(position, path: MovePath, direction):
	if boundaries.is_in_bounds(position):
		_handle_obstacles_at(position, path, direction, "apply_on_enter")
	else:
		path.failed = true
	
	path.add_point(position)


# Attempts to move from the current path endpoint in the given direction
func _leave_position(path: MovePath, direction):
	var position = path.end_position
	var inverse_direction = _invert_direction(direction)
	_handle_obstacles_at(position, path, inverse_direction, "apply_on_exit")
	if not path.failed and not path.finished:
		var to = position + direction
		_enter_position(to, path, direction)


# Attempts to start a path at the given position
func _start_at_position(position, path: MovePath):
	var direction = MovePattern.NO_DIRECTION
	if boundaries.is_in_bounds(position):
		_handle_obstacles_at(position, path, direction, "apply_on_start")
		if not path.failed and not path.finished:
			path.add_point(position)
	else:
		path.failed = true


# Travel along the given path, interacting with obstacles along the way.
func _travel_path(start, path: MovePath, iterations: int) -> Array:
	var paths = []
	var repeated = 1
	_start_at_position(start, path)
	while path.can_continue and (repeated <= iterations or iterations == -1):
		path.finished = false
		
		for instruction in path.instructions:
			if not path.failed and not path.finished:
				_leave_position(path, instruction)
	
		path.finished = true
		if not path.failed:
			_handle_end_obstacles(path.end_position, path)
		else:
			path.can_continue = false
		var duplicate = _duplicate_path(path)
		paths.append(duplicate)
		
		if repeated >= 0:
			repeated += 1
	return paths


# Returns an array of completed paths based on the given MovePattern.
func resolve_pattern(start_position, pattern: MovePattern, obstacles: Array = []) -> Array:
	_obstacles = obstacles
	var results := []
	var paths = _pattern_to_paths(pattern)
	for path in paths:
		var travels = _travel_path(start_position, path, pattern.repeat)
		for travel in travels:
			results.append(travel)
	return results


# Returns an array of all points visited by the successful paths of a MovePattern.
func get_travelled_points(start_position, pattern: MovePattern, obstacles: Array = []) -> Array:
	var points = []
	var paths = resolve_pattern(start_position, pattern, obstacles)
	for path in paths:
		if not path.failed:
			for point in path.path:
				if not point in points:
					points.append(point)
	
	return points
