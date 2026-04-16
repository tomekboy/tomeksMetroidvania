class_name PlayerStateWalk extends PlayerState

# what happens when this state is initialized?
func init() -> void:
	pass


# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "walk" )
	pass


# what happens when we exit this state?
func exit() -> void:
	pass


# what happens when an input is pressed?
func handle_input( event : InputEvent) -> PlayerState:
	if event.is_action_pressed( "dash") and player.can_dash():
		return dash
	if event.is_action_pressed( "attack"):
		return attack
	if event.is_action_pressed( "jump"):
		return jump
	if event.is_action_pressed( "action") and player.can_morph():
		return roll
	return next_state


# what happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if player.direction.x == 0:
		return idle
	elif player.direction.y > 0.5:
		return crouch
	return next_state


# what happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.is_on_floor() == false:
		return fall
	return next_state
