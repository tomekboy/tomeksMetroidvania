extends Sprite2D

const WOODPECKER_SFX = preload("uid://do87v7cvx20ta")

func _on_area_2d_body_entered( body: Node2D ) -> void:
	if body.is_in_group("Player"):
		$AnimationPlayer.play("pecking")
		AudioManager.play_spatial_sound( WOODPECKER_SFX, global_position )
	pass
