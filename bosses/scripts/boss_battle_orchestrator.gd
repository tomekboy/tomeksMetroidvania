@icon( "res://general/icons/boss_orchestrator.svg" )
class_name BossBattleOrchestrator extends Node

@onready var tree_left: TileMapLayer = $"../Visuals/TreeLeft"
@onready var tree_right: TileMapLayer = $"../Visuals/TreeRight"
@onready var audio_stream_player: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"
@onready var fireworks: Node2D = $Fireworks
@onready var rhino_portal: Node2D = $"../StaticObjects/RhinoPortal"

signal battle_started
signal battle_ended

@export var boss : Node
@export var boss_name : String = "bossName"
@export var trigger_area : Area2D
@export var reward : Node2D

@export_category( "Boss Music" )
@export var fight_track : AudioStream

@export_category( "Camera Bounds" )
@export var boss_level_bounds : LevelBounds
@export var original_level_bounds : LevelBounds

const FIREWORKS_SFX = preload("uid://v5t44cwklho5")
const SUCCESS_SFX = preload("uid://dhgm0n54jgsex")
const SPELL_SFX = preload("uid://d1w20jmhofrti")

func _ready() -> void:
	if boss:
		boss.process_mode = Node.PROCESS_MODE_DISABLED
		
	if trigger_area:
		trigger_area.set_collision_mask_value( 5, true)
		trigger_area.body_entered.connect( _on_body_entered )
		
	if reward:
		reward.process_mode = Node.PROCESS_MODE_DISABLED
		reward.visible = false
	pass


func start_boss_battle() -> void:
	battle_started.emit()
	
	rhino_portal.visible = false
	
	if boss_level_bounds:
		boss_level_bounds.set_camera_bounds()
	
	PlayerHud.show_boss_hp( boss_name )
	
	if boss:
		boss.process_mode = Node.PROCESS_MODE_INHERIT
		boss.tree_exiting.connect( end_boss_battle )
		if boss is Enemy:
			boss.was_hit.connect( _on_boss_enemy_hit )
	pass


func end_boss_battle() -> void:
	battle_ended.emit()
	
	AudioManager.play_spatial_sound( FIREWORKS_SFX, Vector2.ZERO )
	fireworks.visible = true
	
	AudioManager.play_spatial_sound( SUCCESS_SFX, Vector2.ZERO )
	rhino_portal.visible = true
	
	if tree_left:
		tree_left.queue_free()
		
	if reward:
		reward.process_mode = Node.PROCESS_MODE_INHERIT
		reward.visible = true
		
	if original_level_bounds:
		original_level_bounds.set_camera_bounds()
		
	PlayerHud.hide_boss_hp()
	await get_tree().create_timer(2.0).timeout
	
	AudioManager.play_spatial_sound( SPELL_SFX, Vector2.ZERO )
	
	if tree_right:
		tree_right.queue_free()
	
	queue_free()
	pass


func _on_body_entered( body : Node2D) -> void:
	if body is Player:
		if tree_left and tree_left.has_method("trigger_slide"):
			tree_left.trigger_slide()
			audio_stream_player.play()
			VisualEffects.camera_shake( 50.0 )
			await audio_stream_player.finished
			
		if tree_right and tree_right.has_method("trigger_slide"):
			tree_right.trigger_slide()
			
		start_boss_battle()
		trigger_area.body_entered.disconnect( _on_body_entered )
		pass
	pass


func _on_boss_enemy_hit( _a : AttackArea ) -> void:
	if boss is Enemy:
		PlayerHud.update_boss_hp( boss.blackboard.health, boss.health )
	pass
