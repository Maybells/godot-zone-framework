class_name EffectGroup


var id: String
var elements := Array()


func _init(id: String, elements: Array = Array()):
	self.id = id
	self.elements = elements


func has(element) -> bool:
	return elements.has(element)


func add(element) -> void:
	elements.append(element)


func reset() -> void:
	elements.clear()
