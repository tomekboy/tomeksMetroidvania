class_name RHStun extends RhinoState

# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var boss : Rhino
# var blackboard : Blackboard

@export var knockback_strength : float = 100
var vel_x : float = 0
var duration : float = 0
var timer : float = 0

func start() -> void:
	var anim : String = animation_name if animation_name else "defend"
	if boss.animation.current_animation == anim:
		boss.animation.seek( 0 )
	else:
		boss.play_animation( anim )
		
	duration = boss.animation.current_animation_length
	timer = 0
	_calc_velocity( blackboard.damage_source )
	blackboard.damage_source = null
	blackboard.can_decide = false
	pass


func enter() -> void:
	start()
	pass


func re_enter() -> void:
	start()
	pass


func exit() -> void:
	blackboard.can_decide = true
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
	
