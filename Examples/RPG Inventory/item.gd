extends DragPiece2D


enum {ARM, CHEST, HEAD, OTHER}


var items = {
	"sword": Vector2(ARM, 1),
	"axe": Vector2(ARM, 2),
	"shield": Vector2(ARM, 3),
	"chestplate": Vector2(CHEST, 1),
	"crown": Vector2(HEAD, 1),
	"helmet": Vector2(HEAD, 2),
	"potion": Vector2(OTHER, 1),
}
var file_prefix = {
	ARM: "arm",
	CHEST: "chest",
	HEAD: "head",
	OTHER: "other",
}


var type
var icon_number


func _ready():
	_load_icon()


func _load_icon():
	# Dictionary bugged in v3.3.rc7, uncomment when fixed
	var prefix #= file_prefix[type]
	if type == ARM:
		prefix = "arm"
	elif type == CHEST:
		prefix = "chest"
	elif type == HEAD:
		prefix = "head"
	else:
		prefix = "other"
	var file = prefix + "_" + str(icon_number) + ".png"
	var image = load("res://Examples/RPG Inventory/Images/" + file)
	$Sprite.texture = image


# Called when piece is picked up
func _on_picked_up():
	if not game.has_focus() and game.can_focus(self):
		z_index += 1
		game.focus_piece(self)
	else:
		$DragMovement2D.release()


# Called when piece is put down
func _on_put_down():
	if game.is_move_valid(self, zone, overlap_zone):
		z_index -= 1
		game.unfocus_piece(self)
		game.move_piece(self, overlap_zone)
	else:
		z_index -= 1
		game.unfocus_piece(self)
		if zone:
			game.move_piece(self, zone)


func set_item(name):
	if name in items:
		var item = items[name]
		type = item.x
		icon_number = item.y
