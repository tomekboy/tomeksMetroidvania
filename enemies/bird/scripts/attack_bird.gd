extends PathFollow2D

@export var speed = 200.0
@onready var sprite = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer


const RAVEN_SFX = preload("uid://clwwemg25b0pp")

var last_x = 0.0

func _ready() -> void:
	animation_player.play("up_and_down")


func _process(delta):
	# Move along the path
	progress += speed * delta
	
	# Determine movement direction
	if global_position.x < last_x:
		sprite.flip_h = true  # Moving Left
	elif global_position.x > last_x:
		sprite.flip_h = false # Moving Right
	
	# Update last position for the next frame
	last_x = global_position.x


func _on_hazard_area_body_entered( body: Node2D ) -> void:
	if body.is_in_group("Player"):
		if PlayerHud.controller_rumble:
			Input.start_joy_vibration(0, 0.3, 0.3, 0.2) # only weak
		AudioManager.play_spatial_sound( RAVEN_SFX, global_position )
		animation_player.play("hurt")
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		animation_player.play("up_and_down")
	pass
