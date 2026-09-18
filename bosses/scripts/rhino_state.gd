@icon( "res://general/icons/state.svg" )
class_name RhinoState extends Node

@export var animation_name : String

var state_machine : RhinoStateMachine
var boss : Rhino
var blackboard : Blackboard

func enter() -> void: pass
func re_enter() -> void: pass
func exit() -> void: pass
func physics_update( _delta : float ) -> void: pass
