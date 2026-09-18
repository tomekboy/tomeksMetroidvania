class_name RHDeath extends RhinoState

# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var boss : Rhino
# var blackboard : Blackboard
@export var knockback_strength : float = 100
@export var death_audio : AudioStream

var vel_x : float = 0
var duration : float = 0
var timer : float = 0

func enter() -> void:
	boss.play_animation( animation_name if animation_name else "die" )
	AudioManager.play_spatial_sound( death_audio, boss.global_position )
	
	duration = boss.animation.current_animation_length
	timer = 0
	
	_calc_velocity( blackboard.damage_source )
	blackboard.damage_source = null
	blackboard.can_decide = false
	
	await boss.animation.animation_finished
	boss.queue_free()
	
	var player : Player = get_tree().get_first_node_in_group( "Player" )
	player.hp += .5
	pass


func re_enter() -> void:
	# What happens if the state is called again?
	pass


func exit() -> void:
	# What do we need to clean up when exiting this state?
	pass


func physics_update( delta : float ) -> void:
	timer += delta
	boss.velocity.x = vel_x * ( 1 - timer / duration )
	if timer >= duration:
		blackboard.can_decide = true
	pass


func _calc_velocity( a : AttackArea ) -> void:
	vel_x = 1
	if a.global_position.x > boss.global_position.x:
		vel_x = -1
	vel_x *= knockback_strength
	pass
	
