tool

# Allows the user to move the parent object by dragging with the mouse.
class_name DragMovement2D

extends KinematicBody2D


# Called when parent starts following the mouse.
signal picked_up
# Called when parent stops following the mouse.
signal put_down


# Load child nodes in advance
onready var _click_shape = $ClickArea/CollisionShape2D
onready var _collision_shape = $CollisionShape2D

# Whether the area can be dragged
export (bool) var enabled := true
# Where the user can click to begin dragging
export (Shape2D) var click_shape = RectangleShape2D.new() setget _click_shape_set
# If false, drag will release when user lets go of the mouse button.
# If true, drag won't release until user clicks a second time.
export (bool) var sticky_click := false
# If true, the dragged area will move so that the mouse is at (0, 0).
# If false, the dragged area will move so that the mouse retains the same relative position.
export (bool) var grab_centered := true
# Whether dragging can change the x position
export (bool) var restrict_x := false
# Whether dragging can change the y position
export (bool) var restrict_y := false
# Whether dragging is blocked by collisions
export (bool) var collision_enabled := false setget _collision_set
# The shape that will be used for collision detection
export (Shape2D) var collision_shape = RectangleShape2D.new() setget _collision_shape_set
# Whether the drag will release if a collision occurs
export (bool) var drop_on_collide := false

# Whether the area is currently being dragged
var dragging := false
# The initial mouse position relative to the dragged area
var _drag_offset := Vector2()
# The initial position of the drag area relative to its parent
var _initial_offset := Vector2()


func _ready():
	_initial_offset = position
	_collision_set(collision_enabled)
	_collision_shape_set(collision_shape)
	_click_shape_set(click_shape)


# If `dragging` is true, moves the parent to the mouse position
func _physics_process(delta):
	if dragging:
		_move_to_mouse(delta)


# If the user clicks the drag area, starts dragging. If the user unclicks, stops dragging.
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		_handle_input(event)
	elif event is InputEventScreenTouch:
		_handle_input(event)


# Begins or stops the drag if possible
func _handle_input(event: InputEvent):
	if _can_pick_up(event):
		pick_up()
		get_tree().set_input_as_handled()
	elif _can_put_down(event):
		put_down()


# Whether the user can start dragging
func _can_pick_up(event: InputEvent) -> bool:
	return enabled and event.pressed and not dragging and _is_in_drag_area(event.position)


# Whether the user can stop dragging
func _can_put_down(event: InputEvent) -> bool:
	return dragging and sticky_click == event.pressed


# Checks if `point` is within the drag area.
func _is_in_drag_area(point: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var results = space_state.intersect_point(point, 32, [], 2147483647, false, true)
	for result in results:
		var collider = result["collider"]
		if collider == $ClickArea:
			return true
	return false


# Moves restricted axes from a vector
func _constrain_movement(movement: Vector2):
	if restrict_x:
		movement.x = 0
	if restrict_y:
		movement.y = 0
	return movement


# Moves toward the mouse, stopping if collision detected.
func _move_to_mouse(delta):
	var target = get_viewport().get_mouse_position() - _drag_offset - global_position
	target = _constrain_movement(target)
	move_and_slide(target / delta)
	get_parent().position = global_position - _initial_offset
	position = _initial_offset
	if drop_on_collide and get_slide_count():
		put_down()


func _collision_set(val: bool):
	$CollisionShape2D.disabled = not val
	collision_enabled = val


func _click_shape_set(val: Shape2D):
	click_shape = val
	if _click_shape:
		_click_shape.shape = val


func _collision_shape_set(val: Shape2D):
	collision_shape = val
	if _collision_shape:
		_collision_shape.shape = val


# Makes the parent start following the mouse.
func pick_up() -> void:
	attach()
	emit_signal("picked_up")


# Makes the parent stop following the mouse.
func put_down() -> void:
	release()
	emit_signal("put_down")


# Makes the parent start following the mouse without triggering a signal
func attach() -> void:
	dragging = true
	if grab_centered:
		_drag_offset = Vector2()
	else:
		_drag_offset = get_viewport().get_mouse_position() - self.global_position


# Makes the parent stop following the mouse without triggering a signal
func release() -> void:
	dragging = false
