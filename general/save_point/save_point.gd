@icon( "res://general/icons/save_point.svg" )
class_name SavePoint extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $Node2D/AnimationPlayer

func _ready() -> void:
	area_2d.body_entered.connect( _on_player_entered )
	area_2d.body_exited.connect( _on_player_exited )
	pass


func _on_player_entered( _n : Node2D ) -> void:
	MessageManager.player_interacted.connect( _on_player_interacted )
	MessageManager.input_hint_changed.emit( "interact" )
	pass


func _on_player_exited( _n : Node2D ) -> void:
	MessageManager.player_interacted.disconnect( _on_player_interacted )
	MessageManager.input_hint_changed.emit( "" )
	pass


func _on_player_interacted( _player : Player ) -> void:
	# heal player
	MessageManager.player_healed.emit( 999 )
	# save game
	SaveManager.save_game()
	# animation
	animation_player.play( "game_saved" )
	animation_player.seek( 0 )
	# play audio
	AudioManager.ui_success()
	pass
