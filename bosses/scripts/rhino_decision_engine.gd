@icon( "res://general/icons/decision_engine.svg" )
class_name RhinoDecisionEngine extends Node

var boss : Rhino
var current_state : RhinoState

var blackboard : Blackboard

func _ready() -> void:
	while not boss:
		await get_tree().process_frame
	boss.change_dir( -1.0 if boss.face_left_on_start else 1.0 )
	pass


func decide() -> RhinoState:
	# Decisions & conditions/checks go here
	return null
