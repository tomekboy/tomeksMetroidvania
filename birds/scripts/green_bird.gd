extends PathFollow2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction = 1
var last_position_x: float = 0.0

func _ready():
	last_position_x = global_position.x
	
func _process(_delta: float) -> void:
	progress_ratio += .0007 * direction
	
	if progress_ratio == 1:
		direction = -1
	if progress_ratio == 0:
		direction = 1
	
	# Check current direction and flip the sprite
	if global_position.x < last_position_x:
		# Moving left
		animated_sprite_2d.flip_h = true
	elif global_position.x > last_position_x:
		# Moving right
		animated_sprite_2d.flip_h = false
		
	# Update last position for the next frame's check
	last_position_x = global_position.x
