@icon( "res://general/icons/state_machine.svg" )
class_name RhinoStateMachine extends Node

var boss : Rhino
var blackboard : Blackboard
var states : Array[ RhinoState ]
var current_state : RhinoState :
	get():
		return states.front()
var prev_state : RhinoState :
	get():
		return states.get( 1 )


func setup( e : Rhino, b : Blackboard ) -> void:
	blackboard = b
	boss = e
	for c in get_children():
		if c is RhinoState:
			c.boss = e
			c.blackboard = b
			c.state_machine = self
			states.append( c )
	current_state.enter()
	pass


func change_state( new_state : RhinoState ) -> void:
	if not new_state:
		return
	
	if new_state == current_state:
		current_state.re_enter()
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front( new_state )
	current_state.enter()
	if boss:
		boss.decision_engine.current_state = new_state
	states.resize( 2 )
	pass


## Called from enemies _physics_process
func physics_update( delta : float ) -> void:
	if current_state:
		current_state.physics_update( delta )
	pass
