# An abstract class for handling grid-based movement and connections
class_name Grid


var boundaries: GridBounds
var obstacles


func _init(boundaries: GridBounds):
	self.boundaries = boundaries


func _obstacles_at(position) -> Array:
	var out := []
	for obstacle in obstacles:
		if obstacle.position == position:
			out.append(obstacle)
	return out


func _pattern_to_paths(pattern):
	pass


func _invert_direction(direction):
	pass


func _duplicate_path(path: MovePath) -> MovePath:
	var duplicate = MovePath.new(path.instructions)
	duplicate.path = path.path.duplicate()
	duplicate.failed = path.failed
	duplicate.finished = path.finished
	duplicate.interactions = path.interactions.duplicate()
	return duplicate


func _handle_obstacle(path: MovePath, obstacle: GridObstacle):
	path.add_interaction(obstacle)
	match obstacle.type:
		GridObstacle.IMPASSABLE:
			path.failed = true
		GridObstacle.STICKY:
			path.finished = true
			path.can_continue = false
		_:
			pass


func _handle_obstacles_at(position, path: MovePath, direction, can_interact := "apply_on_enter"):
	var obs := _obstacles_at(position)
	for obstacle in obs:
		if obstacle.get(can_interact) and obstacle.covers(direction):
			_handle_obstacle(path, obstacle)


func _handle_end_obstacles(position, path: MovePath):
	var obs := _obstacles_at(position)
	for obstacle in obs:
		if obstacle.type == GridObstacle.INVALID_END:
			path.failed = true


func _enter_position(position, path: MovePath, direction):
	if boundaries.is_in_bounds(position):
		_handle_obstacles_at(position, path, direction, "apply_on_enter")
	else:
		path.failed = true
	
	path.add_point(position)


func _leave_position(path: MovePath, direction):
	var position = path.end_position
	var inverse_direction = _invert_direction(direction)
	_handle_obstacles_at(position, path, inverse_direction, "apply_on_exit")
	if not path.failed and not path.finished:
		var to = position + direction
		_enter_position(to, path, direction)


func _start_at_position(position, path: MovePath):
	var direction = MovePattern.NO_DIRECTION
	if boundaries.is_in_bounds(position):
		_handle_obstacles_at(position, path, direction, "apply_on_start")
		if not path.failed and not path.finished:
			path.add_point(position)
	else:
		path.failed = true


func _travel_path(start, path: MovePath, iterations: int) -> Array:
	var paths = []
	var repeated = 1
	_start_at_position(start, path)
	while repeated <= iterations or iterations == -1:
		for instruction in path.instructions:
			if not path.failed and not path.finished:
				_leave_position(path, instruction)
	
		path.finished = true
		if not path.failed:
			_handle_end_obstacles(path.end_position, path)
		var duplicate = _duplicate_path(path)
		paths.append(duplicate)
		
		if repeated >= 0:
			repeated += 1
			
		if path.can_continue and not path.failed:
			path.finished = false
	return paths


func pattern_results(start_position, pattern: MovePattern, obstacles: Array = []):
	self.obstacles = obstacles
	var results := []
	var paths = _pattern_to_paths(pattern)
	for path in paths:
		var travels = _travel_path(start_position, path, pattern.repeat)
		for travel in travels:
			results.append(travel)
	return results
