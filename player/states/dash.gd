class_name PlayerStateDash extends PlayerState

const DASH_SFX = preload("uid://bbk5haegl7mc5")

@export var duration : float = 0.25
@export var speed : float = 300.0
@export var effect_delay : float = 0.05

var dir : float = 1.0
var time : float = 0.0
var effect_time : float = 0.0

@onready var damage_area: DamageArea = %DamageArea

# What happens when this state is initialized?
func init() -> void:
	pass


# What happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "dash" )
	time = duration
	effect_time = 0.0
	get_dash_direction()
	damage_area.make_invulnerable( duration )
	AudioManager.play_spatial_sound( DASH_SFX, player.global_position )
	
	player.gravity_multiplier = 0.0
	player.velocity.y = 0
	
	player.dash_count += 1
	
	player.sprite.tween_color( duration )
	pass


# What happens when we exit this state?
func exit() -> void:
	player.gravity_multiplier = 1.0
	pass


# What happens when an input is pressed?
func handle_input( event : InputEvent ) -> PlayerState:
	if event.is_action_pressed( "action") and player.can_morph():
		return roll
	return null


# What happens each process tick in this state?
func process( delta: float ) -> PlayerState:
	time -= delta
	if time <= 0:
		if player.is_on_floor():
			return idle
		else:
			return fall
	
	effect_time -= delta
	if effect_time < 0:
		effect_time = effect_delay
		player.sprite.ghost()
	return null


# What happens each physics_process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = ( speed * ( time / duration ) + speed ) * dir
	return next_state


func get_dash_direction() -> void:
	dir = 1.0
	if player.sprite.flip_h == true:
		dir = -1.0
	pass
