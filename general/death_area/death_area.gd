@icon("res://general/icons/death_area.svg")
class_name DeathArea extends Node2D

const SCREAM_SFX = preload("uid://dwunjjil02vrk")

@onready var area_2d: Area2D = $Area2D
@onready var player_spawn: PlayerSpawn = $"../PlayerSpawn"

func _ready() -> void:
	area_2d.body_entered.connect( _on_player_entered )
	pass


func _on_player_entered( body : CharacterBody2D ) -> void:
	if body.is_in_group( "Player" ):
		AudioManager.play_spatial_sound( SCREAM_SFX, body.global_position )
		body.hp -= 1
		body.global_position = player_spawn.global_position
	elif body.is_in_group( "Enemy" ):
		body.queue_free()
	pass
