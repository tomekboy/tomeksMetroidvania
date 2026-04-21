class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 550.0

const JUMP_SFX = preload("uid://b45traf8qjvk4")

# what happens when this state is initialized?
func init() -> void:
	pass


# what happens when we enter this state?
func enter() -> void:
	if player.is_on_floor():
		VisualEffects.jump_dust( player.global_position )
	else:
		VisualEffects.hit_dust( player.global_position )
	player.animation_player.play( "jump" )
	player.animation_player.pause()

	do_jump()
	
	# check if this is a buffer jump
	# if it is, handle jump button relese condition retroactively
	if player.previous_state == fall and not Input.is_action_pressed( "jump" ):
		await get_tree().physics_frame
		player.velocity.y *= 0.5
		player.change_state( fall )
	pass


# what happens when we exit this state?
func exit() -> void:
	player.animation_player.play( "fall" )
	pass


# what happens when an input is pressed?
func handle_input( event : InputEvent) -> PlayerState:
	if event.is_action_pressed( "dash") and player.can_dash():
		return dash
	if event.is_action_pressed( "attack"):
		if player.ground_slam and Input.is_action_pressed( "down" ):
			return slam
		return attack
	if event.is_action_released( "jump" ):
		return fall
	if event.is_action_pressed( "action") and player.can_morph():
		return roll
	return next_state


# what happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	set_jump_frame()
	return next_state


# what happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	if can_wall_climb():
		return climb
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.move_speed
	return next_state


func do_jump() -> void:
	if player.jump_count > 0:
		if player.double_jump == false:
			return
		elif player.jump_count > 1:
			return
	player.jump_count += 1
	player.velocity.y = -jump_velocity
	AudioManager.play_spatial_sound( JUMP_SFX, player.global_position )
	pass


func set_jump_frame() -> void:
	var frame : float = remap( player.velocity.y, -jump_velocity, 0.0, 0.0, 1.4 )
	player.animation_player.seek( frame, true )
	pass

func can_wall_climb() -> bool:
	return player.is_on_wall_only() and ( player.wall_climb_right_raycast.is_colliding() or player.wall_climb_left_raycast.is_colliding() )
