extends Node2D


var origin_zone
var overlap_zone
var id
var game


func _process(delta):
	overlap_zone = _get_overlap()


# Returns first overlapping zone. If no zones are in range returns null
func _get_overlap():
	if $ZoneDetector.is_colliding():
		var over = $ZoneDetector.get_collider()
		if over.is_in_group("Zone"):
			return over
		else:
			$ZoneDetector.add_exception(over)
			return _get_overlap()
	else:
		return null