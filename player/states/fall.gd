class_name PlayerStateFall extends PlayerState

@export var fall_gravity_multiplier : float = 1.165
@export var coyote_time : float = 0.125
@export var jump_buffer_time : float = 0.2

var coyote_timer : float = 0
var buffer_timer : float = 0

const FALL_SFX = preload("uid://dgfc5fy7w1ql2")
const LAND_SFX = preload("uid://bxwdus3pl21so")

# what happens when this state is initialized?
func init() -> void:
	pass


# what happens when we enter this state?
func enter() -> void:
	if player.can_wall_climb():
		return
	player.animation_player.play( "fall" )
	player.animation_player.pause()
	player.gravity_multiplier = fall_gravity_multiplier
	
	# handle jump count
	if player.jump_count == 0:
		player.jump_count = 1
	
	var previous_state : PlayerState = player.previous_state
	if previous_state == jump or previous_state == attack or previous_state == dash:
		coyote_timer = 0
	elif player.previous_state == crouch:
		coyote_timer = 0
		player.jump_count = 1
	else:
		coyote_timer = coyote_time
	AudioManager.play_spatial_sound( FALL_SFX, player.global_position )
	pass


# what happens when we exit this state?
func exit() -> void:
	player.gravity_multiplier = 1.0
	buffer_timer = 0
	pass


# what happens when an input is pressed?
func handle_input( event : InputEvent) -> PlayerState:
	if event.is_action_pressed( "dash") and player.can_dash():
		return dash
	if event.is_action_pressed( "attack"):
		if player.ground_slam and Input.is_action_pressed( "down" ):
			return slam
		return attack
	if event.is_action_pressed( "jump" ):
		if coyote_timer > 0:
			player.jump_count = 0
			return jump
		elif player.jump_count <= 1 and player.double_jump:
			return jump
		else:
			buffer_timer = jump_buffer_time
	if event.is_action_pressed( "action") and player.can_morph():
		return roll
	return next_state


# what happens each process tick in this state?
func process( delta: float ) -> PlayerState:
	coyote_timer -= delta
	buffer_timer -= delta
	set_jump_frame()
	return next_state


# what happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	if player.can_wall_climb():
		return climb
	if player.is_on_floor():
		VisualEffects.land_dust( player.global_position )
		AudioManager.play_spatial_sound( LAND_SFX, player.global_position, false, true, 0.5 )
		if buffer_timer > 0:
			player.jump_count = 0
			return jump
		return idle
	player.velocity.x = player.direction.x * player.move_speed
	return next_state


func set_jump_frame() -> void:
	var frame : float = remap( player.velocity.y, 0.0, player.max_fall_velocity, 0.0, 0.75 )
	player.animation_player.seek( frame, true )
	pass
