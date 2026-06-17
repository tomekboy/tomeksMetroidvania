@icon("res://general/icons/player_spawn.svg")
class_name PlayerSpawn extends Node2D

var saved_game : SavedGame
var current_scene_uid : String

func _ready() -> void:
	visible = false
	await get_tree().process_frame
	var player = get_tree().get_first_node_in_group( "Player" )
	
	# we do have a player!
	if player:
		var current_scene : String = get_tree().current_scene.scene_file_path
		current_scene_uid = ResourceUID.path_to_uid( current_scene )
		SaveManager.load_scene_objects( current_scene_uid )
		return
		
	# we do not have a player!
	# instantiate a new instance of our player scene
	
	if int(owner.name) <= 4:
		player = load("uid://bqkwwrgi782w5").instantiate() # polo
		get_tree().root.add_child( player )
		player.global_position = PlayerHud.player_position
	elif int(owner.name) >= 5:
		player = load("uid://hk8xg8lqmqs5").instantiate() # oren
		get_tree().root.add_child( player )
		
	# Position the player
	if PlayerHud.player_position:
		player.global_position = PlayerHud.player_position
	else:
		player.global_position = self.global_position
	pass
