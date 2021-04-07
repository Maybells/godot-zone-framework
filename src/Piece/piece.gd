extends Node2D

class_name Piece


var origin_zone
var overlap_zone
var id
var game
var last_position


func _process(delta):
	if position != last_position:
		last_position = position
		overlap_zone = _get_overlap()


# Returns first overlapping zone. If no zones are in range returns null
func _get_overlap():
	if $ZoneDetector.is_colliding():
		var over = $ZoneDetector.get_collider()
		if over.is_in_group("Zone"):
			return over
		else:
			$ZoneDetector.add_exception(over)
			$ZoneDetector.force_raycast_update()
			return _get_overlap()
	else:
		return null


func return_to_origin():
	origin_zone.reset_piece_position(self)
