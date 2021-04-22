# An singleton that handles the interactions between different Pieces and Zones
class_name GameLogic
extends Node


# Called when the game effects are updated
signal effect_changed


# An array of all pieces associated with the `GameLogic` object
var pieces = Array()
# An array of all zones associated with the `GameLogic` object
var zones = Array()

# A dictionary of `EffectGroup`s stored by id
var _effect_groups := Dictionary()


# Associates a piece with this GameLogic.
func register_piece(piece: Node) -> void:
	piece.game = self
	pieces.append(piece)


# Associates a zone with this GameLogic.
func register_zone(zone: Node) -> void:
	zone.game = self
	zones.append(zone)


# Disassociates a piece from this GameLogic.
func unregister_piece(piece: Node) -> void:
	piece.game = null
	pieces.erase(piece)


# Disassociates a zone from this GameLogic.
func unregister_zone(zone: Node) -> void:
	zone.game = null
	zones.erase(zone)


# Returns true if the game logic allows piece to go from start to end.
func is_move_valid(piece: Node, start: Node, end: Node) -> bool:
	return (end != null) and (end.can_accept_piece(piece))


# Moves piece to the given zone.
func move_piece(piece: Node, to: Node) -> void:
	piece.zone.piece_removed(piece)
	piece.zone = to
	to.piece_added(piece)


# Returns whether something with the given id is included in an effect.
func has_effect(effect: String, id) -> bool:
	if effect in _effect_groups:
		return _effect_groups[effect].has(id)
	return false


# Adds the given id to an effect, creating the effect if not already created.
func add_to_effect(effect: String, id) -> void:
	if effect in _effect_groups:
		_effect_groups[effect].add(id)
	else:
		var e = EffectGroup.new(effect, [id])
		_effect_groups[effect] = e


# Sets an effect to the given array, creating it if not already created.
func set_effect(effect: String, ids: Array) -> void:
	if effect in _effect_groups:
		_effect_groups[effect].elements = ids
	else:
		_effect_groups[effect] = EffectGroup.new(effect, ids)


# Removes all ids from an effect.
func reset_effect(effect: String) -> void:
	if effect in _effect_groups:
		_effect_groups[effect].reset()


# Notify listeners to update effect-based logic.
func update_effects():
	emit_signal("effect_changed")
