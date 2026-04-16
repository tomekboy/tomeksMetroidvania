@icon( "res://general/icons/input_hints.svg" )
class_name InputHints extends Node2D

const HINT_MAP : Dictionary = {
	"keyboard" : {
		"interact" : 4,
		"attack" : 6,
		"jump" : 7,
		"dash" : 1,
		"up" : 5
	},
	"playstation" : {
	"interact" : 11,
	"attack" : 10,
	"jump" : 9,
	"dash" : 8,
	"up" : 0
	},
	"xbox" : {
		"interact" : 19,
		"attack" : 18,
		"jump" : 16,
		"dash" : 17,
		"up" : 0
	},
	"switch" : {
		"interact" : 14,
		"attack" : 15,
		"jump" : 13,
		"dash" : 12,
		"up" : 0
	}
}

var controller_type : String = "keyboard"

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	visible = false
	MessageManager.input_hint_changed.connect( _on_hint_changed )
	pass


func _input( event: InputEvent ) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		controller_type = "keyboard"
	#elif event is InputEventJoypadButton:
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		get_controller_type( event.device )
	pass


func get_controller_type( device_id : int ) -> void:
	var n : String = Input.get_joy_name( device_id ).to_lower()
	
	if "xbox" in n or "xinput" in n:
		controller_type = "xbox"
	elif "playstation" in n or "ps" in n or "dualsense" in n:
		controller_type = "playstation"
	elif "nintendo" in n or "switch" in n:
		controller_type = "switch"
	else:
		controller_type = "xbox"
	set_process_input( true )
	pass


func _on_hint_changed( hint : String ) -> void:
	if hint == "":
		visible = false
	else:
		visible = true
		sprite_2d.frame = HINT_MAP[ controller_type ].get( hint, "0" )
	pass
