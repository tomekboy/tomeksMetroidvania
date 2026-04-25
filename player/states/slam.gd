class_name PlayerStateSlam extends PlayerState

const SLAM01_SFX = preload("uid://jiuvhjuk7hyr")
const SLAM02_SFX = preload("uid://dw3c8e66yg21k")
const WOOD_SMASH_SFX = preload("uid://dgfp2twlqj24")

const HIT_WOOD_LARGE = preload("uid://dwosvte46udf7")
const HIT_WOOD_MEDIUM = preload("uid://bnfjc1g7xt1fo")
const HIT_WOOD_SMALL = preload("uid://d7nm8pwi1pv4")

@export var velocity : float = 500.0
@export var effect_delay : float = 0.075

var effect_timer : float = 0

@onready var damage_area: DamageArea = %DamageArea
@onready var ground_slam_attack_area: AttackArea = %GroundSlamAttackArea
@onready var ground_slam_shape_cast: ShapeCast2D = $"../../GroundSlamShapeCast"

# what happens when this state is initialized?
func init() -> void:
	pass


# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "slam" )
	player.sprite.tween_color()
	AudioManager.play_spatial_sound( SLAM01_SFX, player.global_position, false, true, 0.75 )
	damage_area.start_invulnerable()
	ground_slam_attack_area.set_active()
	pass


# what happens when we exit this state?
func exit() -> void:
	VisualEffects.camera_shake( 10.0)
	VisualEffects.land_dust( player.global_position )
	VisualEffects.hit_dust( player.global_position )
	AudioManager.play_spatial_sound( SLAM02_SFX, player.global_position, false, true, 1.0 )
	damage_area.end_invulnerable()
	ground_slam_attack_area.set_active( false )
	pass


# what happens when an input is pressed?
func handle_input( _event : InputEvent) -> PlayerState:
	return null


# what happens each process tick in this state?
func process( delta: float ) -> PlayerState:
	# collision detection
	check_collisions( delta )
	effect_timer -= delta
	if effect_timer < 0:
		effect_timer = effect_delay
		player.sprite.ghost()
	return null


# what happens each physics process tick in this state?
func physics_process( delta: float ) -> PlayerState:
	player.velocity = Vector2( 0, velocity )
	if player.is_on_floor():
		if not check_collisions( delta ):	
			return idle
	return next_state


func check_collisions( delta : float ) -> bool:
	ground_slam_shape_cast.target_position.y = velocity * delta
	ground_slam_shape_cast.force_shapecast_update()
	if ground_slam_shape_cast.is_colliding():
		for i in ground_slam_shape_cast.get_collision_count():
			var c = ground_slam_shape_cast.get_collider( i )
			var pos : Vector2 = ground_slam_shape_cast.get_collision_point( i )
			
			# handle breakables
			VisualEffects.hit_dust( pos )
			VisualEffects.camera_shake( 10.0 )
			
			if c.get_parent() is Breakable:
				var b : Breakable = c.get_parent()
				b.queue_free()
				AudioManager.play_spatial_sound( b.destroy_audio, pos, false, true, 0.75 )
				for p in b.destroy_particles:
					VisualEffects.hit_particles( pos, Vector2.DOWN, p )
			else:
				c.queue_free()
				VisualEffects.hit_particles( pos, Vector2.DOWN, HIT_WOOD_LARGE )
				VisualEffects.hit_particles( pos, Vector2.DOWN, HIT_WOOD_MEDIUM )
				VisualEffects.hit_particles( pos, Vector2.UP, HIT_WOOD_SMALL )
				AudioManager.play_spatial_sound( WOOD_SMASH_SFX, pos, false, true, 0.75 )
		return true
	return false
