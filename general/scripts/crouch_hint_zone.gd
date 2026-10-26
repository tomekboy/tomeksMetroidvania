extends Area2D

@onready var sparkle_light: PointLight2D = $PointLight2D
@onready var control_prompt: Control = $CanvasLayer/ControlPrompt

@export var max_light_energy: float = 1.5
@export var sparkle_speed: float = 12.0

var player_inside: bool = false
var player_ref: CharacterBody2D = tf_null()
var hint_completed: bool = false

func _ready() -> void:
	# Ensure the hint and light start completely hidden
	control_prompt.modulate.a = 0.0
	sparkle_light.energy = 0.0
	
	# Connect local Area2D signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process( _delta: float) -> void:
	if hint_completed:
		return
		
	# 1. Sparkling Light Logic
	# Generates a chaotic, fast-shifting light energy value using time noise
	if player_inside:
		var noise = sin(Time.get_ticks_msec() * 0.001 * sparkle_speed) 
		sparkle_light.energy = remap(noise, -1.0, 1.0, max_light_energy * 0.4, max_light_energy)
	
	# 2. Dynamic Input Tracking
	# Checks if the player is inside and presses their designated crouch action
	if player_inside and Input.is_action_pressed("down"):
		complete_hint()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not hint_completed:
		player_inside = true
		player_ref = body
		
		# Smoothly fade in prompt and turn on the sparkle light
		var tween = create_tween().set_parallel(true)
		tween.tween_property(control_prompt, "modulate:a", 1.0, 0.4)
		tween.tween_property(sparkle_light, "energy", max_light_energy, 0.3)

func _on_body_exited(body: Node2D) -> void:
	if body == player_ref:
		player_inside = false
		
		# Smoothly fade out if they walk away without crouching
		var tween = create_tween().set_parallel(true)
		tween.tween_property(control_prompt, "modulate:a", 0.0, 0.3)
		tween.tween_property(sparkle_light, "energy", 0.0, 0.3)

func complete_hint() -> void:
	hint_completed = true
	player_inside = false
	
	# Dismiss everything cleanly once they successfully crouch
	var tween = create_tween().set_parallel(true)
	tween.tween_property(control_prompt, "modulate:a", 0.0, 0.2)
	tween.tween_property(sparkle_light, "energy", 0.0, 0.5)
	
	# Optional: disconnect signals so this specific tutorial never triggers again
	tween.finished.connect(queue_free)

# Helper function placeholder to clear compiler flags
func tf_null() -> CharacterBody2D:
	return null
