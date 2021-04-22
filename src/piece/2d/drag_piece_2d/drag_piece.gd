# An extension of `Piece2D` that can be dragged and dropped with the mouse or touch screen while keeping track of which Zone it is over.
class_name DragPiece2D
extends Piece2D


# The zone that is currently underneath the DragPiece2D, can be null.
var overlap_zone: Zone2D


func _ready():
	$OverlapDetector2D.connect("overlap_changed", self, "_on_overlap_changed")
	$DragMovement2D.connect("drag_begun", self, "_on_picked_up")
	$DragMovement2D.connect("drag_ended", self, "_on_put_down")


func _on_overlap_changed(from, to):
	overlap_zone = to


# Called when piece is picked up. Override to add functionality.
func _on_picked_up():
	pass


# Called when piece is put down. Override to add functionality.
func _on_put_down():
	pass


# Changes whether the piece can be picked up.
func set_enabled(enabled: bool) -> void:
	$DragMovement2D.enabled = enabled
