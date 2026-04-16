@icon( "res://general/icons/switch.svg" )
class_name Switch extends Node2D

signal activated

const DOOR_SWITCH_AUDIO = preload("uid://6evvgxyrgroh") # door_switch.wav

var is_open : bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	if SaveManager.persistent_data.get_or_add( unique_name(), "closed" ) == "open":
		set_open()
	else:
		# connect to signals
		area_2d.body_entered.connect( _on_player_entered )
		area_2d.body_exited.connect( _on_player_exited )
		pass
	pass


func _on_player_entered( _n : Node2D ) -> void:
	MessageManager.input_hint_changed.emit( "interact" )
	MessageManager.player_interacted.connect( _on_player_interacted )
	pass


func _on_player_exited( _n : Node2D ) -> void:
	MessageManager.input_hint_changed.emit( "" )
	MessageManager.player_interacted.disconnect( _on_player_interacted )
	pass


func _on_player_interacted( _player : Player) -> void:
	# sfx audio
	AudioManager.play_spatial_sound( DOOR_SWITCH_AUDIO, global_position )
	# persistent data
	SaveManager.persistent_data[ unique_name() ] = "open"
	activated.emit()
	set_open()
	pass


func set_open() -> void:
	is_open = true
	sprite_2d.flip_h = true
	sprite_2d.modulate = Color.GRAY
	area_2d.queue_free()
	pass


func unique_name() -> String:
	var u_name : String = ResourceUID.path_to_uid( owner.scene_file_path )
	u_name += "/" + get_parent().name + "/" + name
	return u_name
