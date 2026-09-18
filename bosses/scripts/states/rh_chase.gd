class_name RHChase extends RhinoState

@export var chase_speed : float = 66

func enter() -> void:
	if owner.name == "Rhino":
		boss.play_animation( "defend" )
	else:
		var anim : String = animation_name if animation_name else "walk"
		if boss.animation.current_animation == anim:
			boss.animation.seek( 0 )
		else:
			boss.play_animation( anim )
	pass


func re_enter() -> void:
	# What happens if the state is called again?
	pass


func exit() -> void:
	# What do we need to clean up when exiting this state?
	pass


func physics_update( _delta : float ) -> void:
	var dir : float = sign( blackboard.target.global_position.x - boss.global_position.x )
	boss.change_dir( dir )
	boss.velocity.x = dir * chase_speed
	pass
	
