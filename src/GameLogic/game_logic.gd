class_name GameLogic

extends Node


signal game_reset
signal game_initialized
signal piece_moved(piece, to)
signal effect_changed


var pieces = Array()
var zones = Array()

var focused_pieces = Array()
var just_unfocused = false

var _effect_groups := Dictionary()


func register_piece(piece):
	piece.game = self
	pieces.append(piece)


func register_zone(zone):
	zone.game = self
	zones.append(zone)


func unregister_piece(piece):
	piece.game = null
	pieces.erase(piece)


func unregister_zone(zone):
	zone.game = null
	zones.erase(zone)


# Returns true if the game logic allows piece to go from start to end
func is_move_valid(piece, start, end):
	return (end != null) and (end.can_accept_piece(piece))


# Moves piece to the given zone
func move_piece(piece, to):
	piece.zone.piece_removed(piece)
	piece.zone = to
	to.piece_added(piece)
	emit_signal("piece_moved", piece, to)


func has_effect(effect: String, object) -> bool:
	if effect in _effect_groups:
		return _effect_groups[effect].has(object)
	return false


func add_to_effect(effect: String, object) -> void:
	if effect in _effect_groups:
		_effect_groups[effect].add(object)
	else:
		var e = EffectGroup.new(effect, [object])
		_effect_groups[effect] = e


func set_effect(effect: String, objects: Array) -> void:
	if effect in _effect_groups:
		_effect_groups[effect].elements = objects
	else:
		_effect_groups[effect] = EffectGroup.new(effect, objects)


func reset_effect(effect: String) -> void:
	if effect in _effect_groups:
		_effect_groups[effect].reset()


func update_effects():
	emit_signal("effect_changed")
