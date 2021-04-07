extends Piece


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
var holding = false


func _ready():
	$ZoneDetector.add_exception($ClickArea)
	
	$ClickArea.connect("input_event", self, "_on_input_event")
	
	_load_icon()


func _process(delta):
	if holding:
		position = get_viewport().get_mouse_position()


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


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed and not holding and not game.has_focus():
				_pick_up()
			elif not event.pressed and game.is_focused(self):
				_put_down()


func _pick_up():
	if not game.has_focus() and game.can_focus(self):
		z_index += 1
		game.focus_piece(self)
		holding = true


func _put_down():
	if game.is_move_valid(self, origin_zone, overlap_zone):
		z_index -= 1
		game.unfocus_piece(self)
		holding = false
		game.move_piece(self, overlap_zone)
	else:
		holding = false
		game.unfocus_piece(self)
		if origin_zone:
			game.move_piece(self, origin_zone)


func set_item(name):
	if name in items:
		var item = items[name]
		type = item.x
		icon_number = item.y
