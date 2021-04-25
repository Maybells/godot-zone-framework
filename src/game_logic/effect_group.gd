# A container of all ids under an effect
class_name EffectGroup


signal updated


# The name of the effect
var name: String
# An array of ids under the effect
var ids := {}
# If true, will store only the most recently added id
var single_id := false
# If true, will store only the most recently added set of parameters for each id
var single_params := true


func _init(name: String, single_id = false, single_params = true):
	self.name = name
	self.single_id = single_id
	self.single_params = single_params


func update() -> void:
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
		if single_params:
			ids[id] = [params]
		else:
			ids[id].append(params)
	else:
		if single_id:
			clear()
		ids[id] = [params]


# Removes all ids from the effect
func clear() -> void:
	ids.clear()


# Remove the given id from the effect
func remove(id) -> void:
	ids.erase(id)
