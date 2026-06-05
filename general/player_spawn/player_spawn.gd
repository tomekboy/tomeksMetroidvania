@icon("res://general/icons/player_spawn.svg")
class_name PlayerSpawn extends Node2D

var player : Player
var saved_game : SavedGame
var current_scene_uid : String

func _ready() -> void:
	visible = false
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group( "Player" )
		
	if player:
		# we have a player!
		var current_scene : String = get_tree().current_scene.scene_file_path
		current_scene_uid = ResourceUID.path_to_uid( current_scene )
		SaveManager.load_scene_objects( current_scene_uid )
		return
		
	# we do not have a player!
	# instantiate a new instance of our player scene
	if int( owner.name ) >= 5:
		player = load("uid://hk8xg8lqmqs5").instantiate() # oren
	else:
		player = load("uid://bqkwwrgi782w5").instantiate() # polo
		
	get_tree().root.add_child( player )
	
	if int( owner.name ) >= 5:
		SaveManager.load_scene_objects( "uid://bk7purnia7v6" )
	
	# Position the player
	player.global_position = self.global_position
	pass
