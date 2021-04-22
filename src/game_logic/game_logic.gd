# An singleton that handles the interactions between different pieces and zones
class_name GameLogic
extends Node


# Called when the game effects are updated
signal effect_changed


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
		return _effect_groups[name].has(id)
	return false


# Adds the given id to an effect, creating the effect if not already created.
func add_to_effect(name: String, id) -> void:
	if name in _effect_groups:
		_effect_groups[name].add(id)
	else:
		var effect = EffectGroup.new(name, [id])
		_effect_groups[name] = effect


# Sets an effect to the given array, creating it if not already created.
func set_effect(name: String, ids: Array) -> void:
	if name in _effect_groups:
		_effect_groups[name].ids = ids
	else:
		_effect_groups[name] = EffectGroup.new(name, ids)


# Removes all ids from an effect.
func reset_effect(name: String) -> void:
	if name in _effect_groups:
		_effect_groups[name].reset()


# Notify listeners to update effect-based logic.
func update_effects():
	emit_signal("effect_changed")
