class_name PlayerStateRoll extends PlayerState

const MORPH_SFX = preload("uid://cr5qeyxkons1t")
const MORPH_OUT_SFX = preload("uid://chkyf2dawsloj")
const JUMP_SFX = preload("uid://b45traf8qjvk4")
const LAND_SFX = preload("uid://bxwdus3pl21so")

@export var jump_velocity : float = 400

var on_floor : bool = true

@onready var roll_top: RayCast2D = %RollTop
@onready var roll_bottom: RayCast2D = %RollBottom

# what happens when this state is initialized?
func init() -> void:
	pass


# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "roll" )
	
	var shape : CapsuleShape2D = player.collision_stand.get_shape() as CapsuleShape2D
	shape.radius = 13.0
	shape.height = 26.0
	
	player.collision_stand.position.y = -16
	player.da_stand.position.y = -16
	
	player.velocity.y -= 100
	AudioManager.play_spatial_sound( MORPH_SFX, player.global_position, false, true, 0.5 )
	
	pass


# what happens when we exit this state?
func exit() -> void:
	player.animation_player.speed_scale = 1
	
	var shape : CapsuleShape2D = player.collision_stand.get_shape() as CapsuleShape2D
	shape.radius = 7.0
	shape.height = 56.0
	player.collision_stand.position.y = -26
	player.da_stand.position.y = -26
	
	player.velocity.y -= 100
	
	AudioManager.play_spatial_sound( MORPH_OUT_SFX, player.global_position, false, true, 0.5 )
	pass


# what happens when an input is pressed?
func handle_input( event : InputEvent) -> PlayerState:
	if event.is_action_pressed( "action" ):
		if _can_stand():
			if player.is_on_floor():
				return idle
			return fall
	if event.is_action_pressed( "jump" ):
		if player.is_on_floor():
			if Input.is_action_pressed( "down" ):
				player.one_way_platform_shape_cast.force_shapecast_update()
				if player.one_way_platform_shape_cast.is_colliding():
					player.position.y += 10
					return null
			player.velocity.y -= jump_velocity
			AudioManager.play_spatial_sound( JUMP_SFX, player.global_position, false, true, 0.5 )
			VisualEffects.jump_dust( player.global_position )
	return null


# what happens each process tick in this state?
func process( _delta: float ) -> PlayerState:
	if player.direction.x == 0:
		player.animation_player.speed_scale = 0
	else:
		player.animation_player.speed_scale = 1
	return null


# what happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	
	if on_floor:
		if not player.is_on_floor():
			on_floor = false
	else:
		if player.is_on_floor():
			on_floor = true
			VisualEffects.land_dust( player.global_position )
			AudioManager.play_spatial_sound( LAND_SFX, player.global_position, false, true, 0.5 )
	return next_state

func _can_stand() -> bool:
	roll_top.force_raycast_update()
	roll_bottom.force_raycast_update()
	if roll_bottom.is_colliding() and roll_top.is_colliding():
		return false
	return true
