class_name ESWalk extends EnemyState

@export var walk_speed : float = 50

var left_limit : float
var right_limit : float
var anim : String = animation_name

func _ready() -> void:
	_set_limits()
	pass


func enter() -> void:
	# What happens when we enter this state?
	if animation_name:
		enemy.play_animation( anim )
		
	if owner.name == "SlimeNature":
		enemy.play_animation( "in_floor_look_left_right" )
	else:
		enemy.play_animation( "move" )
	pass


func re_enter() -> void:
	# What happens if the state is called again?
	pass


func exit() -> void:
	# What do we need to clean up when exiting this state?
	pass


func physics_update( _delta : float ) -> void:
	# What physics do we need to influence while in this state?
	if enemy.is_on_wall():
		enemy.change_dir( -blackboard.dir )
	elif enemy.global_position.x <= left_limit and blackboard.dir < 0:
		enemy.change_dir( 1.0 )
	elif enemy.global_position.x >= right_limit and blackboard.dir > 0:
		enemy.change_dir( -1.0 )
	enemy.velocity.x = walk_speed * blackboard.dir
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
