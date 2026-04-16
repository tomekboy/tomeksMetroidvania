@icon("res://general/icons/death_area.svg")
class_name DeathArea extends Node2D

const SCREAM_SFX = preload("uid://dwunjjil02vrk")

@onready var area_2d: Area2D = $Area2D
@onready var player_spawn: PlayerSpawn = $"../PlayerSpawn"


func _ready() -> void:
	area_2d.body_entered.connect( _on_player_entered )
	pass


func _on_player_entered( player : CharacterBody2D ) -> void:
	#SceneManager.transition_scene( SceneManager.current_scene_uid, "", Vector2.ZERO, "up" )
	AudioManager.play_spatial_sound( SCREAM_SFX, player.global_position )
	player.global_position = player_spawn.global_position
	pass
