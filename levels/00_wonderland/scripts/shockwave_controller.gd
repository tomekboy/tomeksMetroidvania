extends ColorRect

@onready var shader_mat: ShaderMaterial = material as ShaderMaterial

func _ready() -> void:
	# Keep the effect invisible at launch
	shader_mat.set_shader_parameter("size", 0.0)
	shader_mat.set_shader_parameter("force", 0.0)
	MessageManager.shockwave_requested.connect( trigger_shockwave )
	
## Call this function from your player, explosion, or projectile script
func trigger_shockwave(global_impact_position: Vector2) -> void:
	# 1. Convert the world space position to screen space pixels
	var screen_pixels: Vector2 = get_viewport().get_canvas_transform() * global_impact_position
	
	# 2. Normalize screen pixels to UV space (0.0 to 1.0)
	var screen_size: Vector2 = get_viewport_rect().size
	var uv_position: Vector2 = screen_pixels / screen_size
	
	# 3. Initialize shader variables at the blast epicenter
	shader_mat.set_shader_parameter("center", uv_position)
	shader_mat.set_shader_parameter("force", 0.06) # Starting displacement strength
	shader_mat.set_shader_parameter("size", 0.0)    # Starting radius
	
	# 4. Animate the wave expanding while fading out the strength simultaneously
	var tween: Tween = create_tween()
	
	# Expand the ring outward to a radius of 1.4 over 0.6 seconds
	tween.parallel().tween_property(shader_mat, "shader_parameter/size", 1.4, 0.6)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		
	# Smoothly drop displacement intensity to zero over the same duration
	tween.parallel().tween_property(shader_mat, "shader_parameter/force", 0.0, 0.6)\
		.set_trans(Tween.TRANS_LINEAR)
