extends AnimatedSprite2D

const FART_SFX = preload("uid://dgh600u037h4n")

func _on_fart_area_body_entered( _body: Node2D ) -> void:
	AudioManager.play_spatial_sound( FART_SFX, global_position )
	pass
