# A container of all ids under an effect
class_name EffectGroup


signal updated


# The name of the effect
var name: String
# An array of ids under the effect
var ids := {}


func _init(name: String, ids: Dictionary = {}):
	self.name = name
	self.ids = ids


func update():
	emit_signal("updated")


# Returns whether the given id is under the effect.
func is_affected(id) -> bool:
	return id in ids


# Returns an array of all effect params associated with the given id.
# If given id is not under the effect, returns an empty array.
func get_params_at(id) -> Array:
	if is_affected(id):
		return ids[id]
	return []


# Adds the given id to the effect with the given parameters
func add(id, params: Dictionary = {}) -> void:
	if id in ids:
		ids[id].append(params)
	else:
		ids[id] = [params]


# Removes all ids from the effect
func clear() -> void:
	ids.clear()


# Remove the given id from the effect
func remove(id) -> void:
	ids.erase(id)
