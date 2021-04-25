class_name MovePath


# The positions the path went through before stopping
var path := Array()
# The sequence of move which the path attepted to follow
var instructions := Array()
# Whether or not the path was stopped by an obstacle or boundary before finishing
var failed := false
# Whether or not the path has reached an end
var finished := false
# Whether or not a repeated movement can continue from end_position
var can_continue := true
# The first point of the path
var start_position setget ,_start_position_get
# The final point of the path
var end_position setget ,_end_position_get
# The obstacles which the path went over
var interactions := Array()


func _init(instructions: Array):
	self.instructions = instructions


func _start_position_get():
	return path.front()


func _end_position_get():
	return path.back()


func add_point(point):
	path.append(point)


func add_interaction(obstacle: GridObstacle):
	interactions.append(obstacle)
