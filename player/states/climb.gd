class_name PlayerStateClimb extends PlayerState

const HAMMER_SFX = preload("uid://25ei061s5ks5")

# what happens when this state is initialized?
func init() -> void:
	pass


# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "climb" )
	AudioManager.play_spatial_sound( HAMMER_SFX, player.global_position )
	pass

# what happens when we exit this state?
func exit() -> void:
	player.wall_climb_timer.start()

# what happens when an input is pressed?
func handle_input( _event : InputEvent) -> PlayerState:
	return null

# what happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	return null


# what happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	if not Input.is_action_pressed("left") and player.wall_climb_left_raycast.is_colliding():
		return idle
	if player.is_on_wall_only():
		player.velocity.y = player.wall_slide_velocity
		player.animation_player.play( "slide" )
		if Input.is_action_just_pressed( "jump" ):
			if player.wall_climb_left_raycast.is_colliding():
				player.velocity = Vector2( player.wall_x_force, player.wall_y_force )
				player.sprite.flip_h = true
				return jump
			if player.wall_climb_right_raycast.is_colliding():
				player.velocity = Vector2( -player.wall_x_force, player.wall_y_force )
				player.sprite.flip_h = false
				return jump
	return next_state
