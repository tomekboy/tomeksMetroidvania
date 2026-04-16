class_name PlayerStateCrouch extends PlayerState

@export var deceleration_rate : float = 10

# what happens when this state is initialized?
func init() -> void:
	pass


# what happens when we enter this state?
func enter() -> void:
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.da_stand.disabled = true
	player.da_crouch.disabled = false
	player.animation_player.play( "crouch" )
	pass


# what happens when we exit this state?
func exit() -> void:
	player.collision_stand.set_deferred( "disabled", false )
	player.collision_crouch.set_deferred( "disabled", true )
	player.da_stand.set_deferred( "disabled", false )
	player.da_crouch.set_deferred( "disabled", true )
	pass


# what happens when an input is pressed?
func handle_input( _event : InputEvent ) -> PlayerState:
	if _event.is_action_pressed( "dash" ) and player.can_dash():
		return dash
	if _event.is_action_pressed( "attack" ):
		return attack
	if _event.is_action_pressed( "jump" ):
		player.one_way_platform_shape_cast.force_shapecast_update()
		if player.one_way_platform_shape_cast.is_colliding():
			player.position.y += 4
			return fall
		return jump
	if _event.is_action_pressed( "action" ) and player.can_morph():
		return roll
	return next_state


# what happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if player.direction.y <= 0.5:
		return idle
	return next_state


# what happens each physics process tick in this state?
func physics_process( delta: float ) -> PlayerState:
	player.velocity.x -= player.velocity.x * deceleration_rate * delta
	if player.is_on_floor() == false:
		return fall
	return next_state
