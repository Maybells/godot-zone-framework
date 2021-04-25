class_name SquareGrid
extends Grid


# ORTHOGONAL means only left, right, up, and down are counted as adjacent
# OCTILINEAR is ORTHOGONAL adjacency plus diagonals
enum {ORTHOGONAL, OCTILINEAR}


func _init(boundaries).(boundaries):
	pass


func _pattern_to_paths(pattern: SquareMovePattern) -> Array:
	var paths = []
	paths += [MovePath.new( pattern.sequence )]
	
	match pattern.mode:
		SquareMovePattern.NONE:
			pass
		SquareMovePattern.MIRROR_X:
			paths += [MovePath.new( pattern.get_mirror_x() )]
		SquareMovePattern.MIRROR_Y:
			paths += [MovePath.new( pattern.get_mirror_y())]
		SquareMovePattern.MIRROR_XY:
			paths += [MovePath.new( pattern.get_mirror_x() )]
			paths += [MovePath.new( pattern.get_mirror_y() )]
			paths += [MovePath.new( pattern.get_mirror_diagonal() )]
		SquareMovePattern.MIRROR_DIAGONAL:
			paths += [MovePath.new( pattern.get_mirror_diagonal() )]
		SquareMovePattern.ROTATE_HALF:
			paths += [MovePath.new( pattern.get_rotation(2) )]
		SquareMovePattern.ROTATE_MIRROR:
			paths += [MovePath.new( pattern.get_mirror_rotation(0) )]
			paths += [MovePath.new( pattern.get_mirror_rotation(1) )]
			paths += [MovePath.new( pattern.get_mirror_rotation(2) )]
			paths += [MovePath.new( pattern.get_mirror_rotation(3) )]
			paths += [MovePath.new( pattern.get_rotation(1) )]
			paths += [MovePath.new( pattern.get_rotation(2) )]
			paths += [MovePath.new( pattern.get_rotation(3) )]
		SquareMovePattern.ROTATE_FULL:
			paths += [MovePath.new( pattern.get_rotation(1) )]
			paths += [MovePath.new( pattern.get_rotation(2) )]
			paths += [MovePath.new( pattern.get_rotation(3) )]
	
	return paths


func _invert_direction(direction):
	match direction:
		SquareMovePattern.LEFT:
			return SquareMovePattern.RIGHT
		SquareMovePattern.RIGHT:
			return SquareMovePattern.LEFT
		SquareMovePattern.UP:
			return SquareMovePattern.DOWN
		SquareMovePattern.DOWN:
			return SquareMovePattern.UP
		SquareMovePattern.DIAG_DL:
			return SquareMovePattern.DIAG_UR
		SquareMovePattern.DIAG_DR:
			return SquareMovePattern.DIAG_UL
		SquareMovePattern.DIAG_UL:
			return SquareMovePattern.DIAG_DR
		SquareMovePattern.DIAG_UR:
			return SquareMovePattern.DIAG_DL
		_:
			return direction
