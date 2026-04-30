class_name ESAttack extends EnemyState

@export var walk_speed : float = 100

func enter() -> void:
	# What happens when we enter this state?
	var anim : String = animation_name if animation_name else "attack_right"
	enemy.play_animation( anim )
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
	enemy.velocity.x = walk_speed * blackboard.dir
	pass
