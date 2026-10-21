class_name RHChase extends EnemyState

@export var chase_speed : float = 100

var left_limit : float
var right_limit : float
var dir : float = 1.0
var dir_changed_cooldown : float = 0.0

func enter() -> void:
	enemy.play_animation( animation_name if animation_name else "walk_smashing" )
	_set_limits()
	dir_changed_cooldown = -1.0
	pass


func re_enter() -> void:
	# What happens if the state is called again?
	pass


func exit() -> void:
	# What do we need to clean up when exiting this state?
	pass


func physics_update( delta : float ) -> void:
	if blackboard.target:
		if dir_changed_cooldown > 0:
			dir_changed_cooldown -= delta
		else:
			dir_changed_cooldown = 0.5
		
		if enemy.is_on_wall():
			enemy.change_dir( -blackboard.dir )
		elif enemy.global_position.x <= left_limit and blackboard.dir < 0:
			enemy.change_dir( 1.0 )
		elif enemy.global_position.x >= right_limit and blackboard.dir > 0:
			enemy.change_dir( -1.0 )
			
		dir = sign( blackboard.target.global_position.x - enemy.global_position.x )
			
		enemy.velocity.x = dir * chase_speed
	pass


func _set_limits() -> void:
	left_limit = owner.global_position.x - 5000
	right_limit = owner.global_position.x + 5000
	for c in owner.get_children():
		if c is PatrolLimit:
			if c.side == Side.SIDE_LEFT:
				left_limit = c.global_position.x
			else:
				right_limit = c.global_position.x
	pass
