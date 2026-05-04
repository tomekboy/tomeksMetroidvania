extends PathFollow2D

var direction = 1

func _ready() -> void:
	$AnimatedSprite2D.flip_h = true
	
func _process(_delta: float) -> void:
	progress_ratio += .0007 * direction
	if progress_ratio == 1:
		direction = -1
		$AnimatedSprite2D.flip_h = false
	if progress_ratio == 0:
		direction = 1
		$AnimatedSprite2D.flip_h = true
