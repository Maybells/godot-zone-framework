class_name GridGameLogic
extends GameLogic


var grid: Grid
var zone_locations := {}


func _init(grid: Grid).():
	self.grid = grid


func add_zone_at(zone, location) -> void:
	register_zone(zone)
	zone_locations[location] = zone


func get_zone_at(location):
	if location in zone_locations:
		return zone_locations[location]
	return null
