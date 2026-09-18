@icon( "res://general/icons/boss_orchestrator.svg" )
class_name BossBattleOrchestrator extends Node

@onready var tree_left: TileMapLayer = $"../Visuals/TreeLeft"
@onready var audio_stream_player: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"

signal battle_started
signal battle_ended

@export var boss : Node
@export var boss_name : String = "bossName"
@export var trigger_area : Area2D
@export var reward : Node2D

@export_category( "Boss Music" )
@export var fight_track : AudioStream
@export var post_fight_track : AudioStream

@export_category( "Camera Bounds" )
@export var boss_level_bounds : LevelBounds
@export var original_level_bounds : LevelBounds

var bus_idx = AudioServer.get_bus_index("Music")
var current_db = AudioServer.get_bus_volume_db(bus_idx)
const YOU_WIN = preload("uid://5g6lbdcgwp8b")

func _ready() -> void:
	if boss:
		boss.process_mode = Node.PROCESS_MODE_DISABLED
		
	if trigger_area:
		trigger_area.set_collision_mask_value( 5, true)
		trigger_area.body_entered.connect( _on_body_entered )
		
	if reward:
		reward.process_mode = Node.PROCESS_MODE_DISABLED
		reward.visible = false
		
	if SaveManager.persistent_data.get_or_add( unique_name(), "" ) == "defeated":
		queue_free()
		var magic_portal_scene = preload( "uid://bbktiy3mf8gp8" )
		var portal = magic_portal_scene.instantiate()
		portal.position = Vector2(789, 553)
		get_tree().get_root().get_node( "04Boss/StaticObjects" ).add_child( portal )
	pass


func start_boss_battle() -> void:
	battle_started.emit()
	
	if boss_level_bounds:
		boss_level_bounds.set_camera_bounds()
	
	AudioServer.set_bus_volume_db(bus_idx, current_db + 5.0)
	AudioManager.play_music( fight_track )
	PlayerHud.show_boss_hp( boss_name )
	
	if boss:
		boss.process_mode = Node.PROCESS_MODE_INHERIT
		boss.tree_exiting.connect( end_boss_battle )
		if boss is Enemy:
			boss.was_hit.connect( _on_boss_enemy_hit )
	pass


func end_boss_battle() -> void:
	battle_ended.emit()
	
	SaveManager.persistent_data[ unique_name() ] = "defeated"
	
	if tree_left:
		tree_left.queue_free()
	
	if reward:
		reward.process_mode = Node.PROCESS_MODE_INHERIT
		reward.visible = true
		
	if original_level_bounds:
		original_level_bounds.set_camera_bounds()
		
	AudioManager.play_spatial_sound( YOU_WIN, Vector2.ZERO)
	AudioManager.play_music( post_fight_track )
	AudioServer.set_bus_volume_db(bus_idx, current_db - 5.0)
	PlayerHud.hide_boss_hp()
	
	queue_free()
	pass


func _on_body_entered( body : Node2D) -> void:
	if body is Player:
		if tree_left and tree_left.has_method("trigger_slide"):
			tree_left.trigger_slide()
			audio_stream_player.play()
			VisualEffects.camera_shake( 25.0 )
			await audio_stream_player.finished
		start_boss_battle()
		trigger_area.body_entered.disconnect( _on_body_entered )
		pass
	pass


func unique_name() -> String:
	var u_name : String = ResourceUID.path_to_uid( owner.scene_file_path )
	u_name += "/" + get_parent().name + "/" + name
	#needed for player hud decision on boss awakening
	#print( u_name )
	return u_name


func _on_boss_enemy_hit( _a : AttackArea ) -> void:
	if boss is Enemy:
		PlayerHud.update_boss_hp( boss.blackboard.health, boss.health )
	pass
