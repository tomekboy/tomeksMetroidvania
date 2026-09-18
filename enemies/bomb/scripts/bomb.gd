extends Node

const EXPLOSION = preload("uid://c4e8itua0fpyd")
const EXPLOSION_SFX = preload("uid://so0iorkw7d48")

func _ready() -> void:
	pass


func _on_timer_timeout() -> void:
	var e = EXPLOSION.instantiate()
	e.position = self.position
	add_sibling(e)
	e.emitting = true
	AudioManager.play_spatial_sound( EXPLOSION_SFX, Vector2.ZERO )
	queue_free()
	pass
