# A model that handles the interactions between different pieces and zones
class_name GameLogic
extends Node


# Called when the game effects are updated
signal effect_changed


# If true, each id in an effect can only have one set of parameters. Adding a new set will overwrite the first.
# If false, an id can have multiple sets of parameters.
export (bool) var single_effect_params = true

# An array of all pieces associated with this GameLogic
var pieces = Array()
# An array of all zones associated with this GameLogic
var zones = Array()

# A dictionary of EffectGroups stored by name
var _effect_groups := Dictionary()


# Associates a piece with this GameLogic.
func register_piece(piece) -> void:
	piece.game = self
	pieces.append(piece)


# Associates a zone with this GameLogic.
func register_zone(zone) -> void:
	zone.game = self
	zones.append(zone)


# Disassociates a piece from this GameLogic.
func unregister_piece(piece) -> void:
	piece.game = null
	pieces.erase(piece)


# Disassociates a zone from this GameLogic.
func unregister_zone(zone) -> void:
	zone.game = null
	zones.erase(zone)


# Returns true if the game logic allows piece to go from start to end.
func is_move_valid(piece, start, end) -> bool:
	return (end != null) and (end.can_accept_piece(piece))


# Moves piece to the given zone.
func move_piece(piece, zone) -> void:
	piece.zone.piece_removed(piece)
	piece.zone = zone
	zone.piece_added(piece)


# Returns whether something with the given id is included in an effect.
func has_effect(name: String, id) -> bool:
	if name in _effect_groups:
		return _effect_groups[name].is_affected(id)
	return false


# Adds the given id to an effect, creating the effect if not already created.
func add_to_effect(name: String, id, params: Dictionary = {}) -> void:
	if single_effect_params:
		remove_from_effect(name, id)
	
	if name in _effect_groups:
		_effect_groups[name].add(id, params)
	else:
		var effect = EffectGroup.new(name)
		effect.add(id, params)
		_effect_groups[name] = effect


# Removes the given id from an effect.
func remove_from_effect(name: String, id) -> void:
	if name in _effect_groups:
		_effect_groups[name].remove(id)


# Gets the parameters associated with id in the given effect.
# If `single_effect_params` is true, returns a dictionary
# If `single_effect_params` is false, returns an array of dictionaries
func get_effect_params(name: String, id):
	if name in _effect_groups:
		if single_effect_params:
			var params = _effect_groups[name].get_params_at(id)
			if params.empty():
				return {}
			else:
				return params.first()
		else:
			return _effect_groups[name].get_params_at(id)
	return null


# Removes all ids from an effect.
func reset_effect(name: String) -> void:
	if name in _effect_groups:
		_effect_groups[name].clear()


# Notify listeners to update effect-based logic.
func update_effects():
	emit_signal("effect_changed")
