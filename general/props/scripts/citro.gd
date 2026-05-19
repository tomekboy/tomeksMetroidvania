extends CharacterBody2D

@onready var cherry: CharacterBody2D = $"."

@export var burstParticle : PackedScene

const SQUASH_SFX = preload("uid://cm7g7cuq4h5di")
var explosion

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		explosion = burstParticle.instantiate()
		get_tree().current_scene.add_child(explosion)
		explosion.position = self.global_position
		explosion.emitting = true
		AudioManager.play_spatial_sound( SQUASH_SFX, global_position )
		Input.start_joy_vibration(0,0,0.5,0.5)
		$Timer.start()
	pass


func _on_timer_timeout() -> void:
	queue_free()
	explosion.queue_free()
	pass
