class_name PlayerStateClimb extends PlayerState

# what happens when this state is initialized?
func init() -> void:
	pass


# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "climb" )

	pass


# what happens when we exit this state?
func exit() -> void:
	pass


# what happens when an input is pressed?
func handle_input( event : InputEvent) -> PlayerState:
	return null


# what happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	return null


# what happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	if player.is_on_wall_only():
		player.velocity.y = player.wall_slide_velocity
		if Input.is_action_just_pressed( "jump" ):
			if player.wall_climb_left_raycast.is_colliding():
				player.velocity = Vector2( player.wall_x_force, player.wall_y_force )
				player.sprite.flip_h = false
				wall_jumping()
			if player.wall_climb_right_raycast.is_colliding():
				player.velocity = Vector2( -player.wall_x_force, player.wall_y_force )
				player.sprite.flip_h = true
				wall_jumping()
	return next_state
 
func wall_jumping() -> void:
	player.is_wall_jumping = true
	await get_tree().create_timer( 0.12 ).timeout
	player.is_wall_jumping = false
	pass
