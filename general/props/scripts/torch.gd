extends AnimatedSprite2D

const MATCH_LIGHT_SFX = preload("uid://bjou08svdnx84")

@onready var torch: AnimatedSprite2D = $"."
@onready var area_2d: Area2D = $Area2D


func _on_area_2d_body_entered( _body: Node2D ) -> void:
	torch.play("lid")
	AudioManager.play_spatial_sound( MATCH_LIGHT_SFX, Vector2.ZERO )
	pass
