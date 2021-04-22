# A container of all ids under an effect
class_name EffectGroup


# The name of the effect
var name: String
# An array of ids under the effect
var ids := Array()


func _init(name: String, ids: Array = Array()):
	self.name = name
	self.ids = ids


# Returns whether the given id is under the effect.
func has(id) -> bool:
	return ids.has(id)


# Adds the given id to the effect
func add(id) -> void:
	ids.append(id)


# Removes all ids from the effect
func reset() -> void:
	ids.clear()
