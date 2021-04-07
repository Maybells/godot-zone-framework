extends Node2D


onready var slot = load("res://Examples/RPG Inventory/ItemBox.tscn")
onready var item = load("res://Examples/RPG Inventory/Item.tscn")
onready var game = InventoryLogic.new()


var starting_items = {
	0: "crown",
	1: "helmet",
	2: "axe",
	3: "chestplate",
	13: "potion",
	14: "potion",
	15: "potion",
	16: "potion",
	17: "potion",
}


func _ready():
	game.register_zone($Head)
	game.register_zone($Chest)
	game.register_zone($LeftArm)
	game.register_zone($RightArm)
	
	var i = 0
	for point in $SquareGridGenerator.points:
		var box = slot.instance()
		box.position = $SquareGridGenerator.position + point
		game.register_zone(box)
		add_child(box)
		
		if i in starting_items:
			box.piece_added(_generate_item(starting_items[i]))
		
		i += 1
	
	var sword = _generate_item("sword")
	$RightArm.piece_added(sword)
	
	var shield = _generate_item("shield")
	$LeftArm.piece_added(shield)


func _generate_item(name):
	var i = item.instance()
	i.set_item(name)
	game.register_piece(i)
	add_child(i)
	return i
