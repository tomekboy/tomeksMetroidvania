@icon( "res://general/icons/music_trigger.svg" )
class_name MusicAutoTrigger extends Node

@export var track : AudioStream
@export var reverb : AudioManager.REVERB_TYPE = AudioManager.REVERB_TYPE.NONE


func _ready() -> void:
	AudioManager.play_music( track )
	AudioManager.set_reverb( reverb )
	pass
