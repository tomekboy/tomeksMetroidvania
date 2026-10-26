class_name RHShockwave extends EnemyState

@onready var shockwave_rect: ColorRect = $"../../../../Ambiance/Shockwave/CanvasLayer/ShockwaveColorRect"
@onready var shockwave_area: Area2D = $"../../../../Ambiance/Shockwave/CanvasLayer/ShockwaveColorRect/ShockwaveArea2D"
@onready var collision_shape: CollisionShape2D = $"../../../../Ambiance/Shockwave/CanvasLayer/ShockwaveColorRect/ShockwaveArea2D/ShockwaveCollisionShape2D"

@export var wave_duration: float = 1.5
@export var wave_max_radius: float = 1.2
@export var wave_pixel_height: float = 400.0
 
const SHOCKWAVE_SFX = preload("uid://7tmyci5i8onr")

var is_running: bool = false

func _ready() -> void:
	if shockwave_rect:
		shockwave_rect.hide()

func enter() -> void:
	super()
	if not shockwave_rect or not shockwave_area or not collision_shape:
		push_error("RHShockwave: Missing node assignments in Inspector.")
		return
		
	is_running = true
	execute_shockwave()

func execute_shockwave() -> void:
	
	AudioManager.play_spatial_sound( SHOCKWAVE_SFX, enemy.global_position)
	
	var viewport_size = enemy.get_viewport_rect().size
	var mat = shockwave_rect.material as ShaderMaterial
	
	if not mat:
		push_error("RHShockwave: ColorRect missing a ShaderMaterial.")
		return

	# Setup initial vertical lane scale constraints (250px)
	mat.set_shader_parameter("wave_height_uv", (wave_pixel_height / 2.0) / viewport_size.y)
	mat.set_shader_parameter("current_radius", 0.0)
	
	shockwave_rect.show()
	shockwave_area.monitoring = true
	
	# Match physical Area2D height settings
	var rect_shape = collision_shape.shape as RectangleShape2D
	if rect_shape:
		rect_shape.size.y = wave_pixel_height
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(mat, "shader_parameter/current_radius", wave_max_radius, wave_duration)
	
	# DYNAMIC UPDATER METHOD
	# Tracks enemy's real-time screen position while moving the shockwave outward
	tween.tween_method(func(radius: float):
		if not is_instance_valid(enemy) or not is_instance_valid(shockwave_rect):
			return
			
		# 1. Track the enemy's moving screen position position right now
		var enemy_screen_pos = enemy.get_global_transform_with_canvas().origin
		var current_viewport_size = enemy.get_viewport_rect().size
		var center_uv = enemy_screen_pos / current_viewport_size
		
		# 2. Update shader origin coordinates mid-travel
		mat.set_shader_parameter("center_uv", center_uv)
		
		# 3. Handle physical Area2D movement matching the visual radius
		var current_width = radius * current_viewport_size.x
		if rect_shape:
			rect_shape.size.x = current_width * 2
			
		if is_instance_valid(shockwave_area):
			shockwave_area.global_position = enemy.global_position, 0.0, wave_max_radius, wave_duration)
	
	await tween.finished
	
	mat.set_shader_parameter("current_radius", 0.0)
	shockwave_rect.hide()
	shockwave_area.monitoring = false
	is_running = false

func can_attack() -> bool:
	return not is_running
