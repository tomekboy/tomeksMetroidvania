extends Node2D

const WARP_SFX = preload("uid://booy0feda5vsb")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		AudioManager.play_spatial_sound( WARP_SFX, body.global_position  )
		$AnimationPlayer.play("fade_out")
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		$AnimationPlayer.play("RESET")
		self.queue_free()
	pass
