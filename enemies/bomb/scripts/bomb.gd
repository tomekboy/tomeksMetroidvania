extends RigidBody2D

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


func _on_hazard_area_body_entered( body: Node2D ) -> void:
	if body.is_in_group("Player"):
		stop_movement()
	pass


func stop_movement() -> void:
	# Instantly zeros out linear and angular momentum
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	
	# Freezes the body into a static state so gravity and forces stop affecting it
	set_deferred("freeze_mode", RigidBody2D.FREEZE_MODE_STATIC)
	set_deferred("freeze", true)
	
