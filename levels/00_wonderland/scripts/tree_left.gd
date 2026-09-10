extends TileMapLayer

@export var slide_duration: float = 0.6
@export var camera: Camera2D # Drag your Camera2D here in the Inspector
@export var shake_force: float = 15.0

var target_position: Vector2
var has_slid: bool = false

func _ready() -> void:
	# Save where it belongs, then hide it off-screen immediately
	target_position = position
	position.y = get_viewport_rect().size.y


func trigger_slide() -> void:
	if has_slid: return # Prevent triggering multiple times
	has_slid = true
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", target_position.y, slide_duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	# Connect to the "finished" signal of the tween to shake the camera
	tween.finished.connect(_on_slide_finished)


func _on_slide_finished() -> void:
	if camera and camera.has_method("apply_shake"):
		camera.apply_shake(shake_force)
