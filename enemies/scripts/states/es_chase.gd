class_name ESChase extends EnemyState

@export var chase_speed : float = 100

func enter() -> void:
	if owner.name == "Rhino":
		enemy.play_animation( "defend" )
	else:
		var anim : String = animation_name if animation_name else "bite"
		if enemy.animation.current_animation == anim:
			enemy.animation.seek( 0 )
		else:
			enemy.play_animation( anim )
	pass


func re_enter() -> void:
	# What happens if the state is called again?
	pass


func exit() -> void:
	# What do we need to clean up when exiting this state?
	pass


func physics_update( _delta : float ) -> void:
	var dir : float = sign( blackboard.target.global_position.x - enemy.global_position.x )
	enemy.change_dir( dir )
	enemy.velocity.x = dir * chase_speed
	pass
	
