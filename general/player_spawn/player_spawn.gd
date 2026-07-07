@icon("res://general/icons/player_spawn.svg")
class_name PlayerSpawn extends Node2D

var saved_game : SavedGame
var current_scene_uid : String

func _ready() -> void:
	visible = false
	await get_tree().process_frame
	var player = get_tree().get_first_node_in_group( "Player" )
		# instantiate a new instance of our player scene
		# change character to the appropriate defined scene range
	if int(owner.name) <= 4:
		player = load("uid://bqkwwrgi782w5").instantiate() # polo

	elif int(owner.name) >= 5:
		player = load("uid://hk8xg8lqmqs5").instantiate() # oren
		
	get_tree().root.add_child( player )
		
	SaveManager.load_scene( current_scene_uid )
	
	# determine F5 or F6 start
	if PlayerHud.debug_mode == false:
		#load the player related data as we want to keep it coherent over scene changes
		player.global_position = PlayerHud.player_position
		player.hp = PlayerHud.player_hp
		player.cp = PlayerHud.player_cp
		
		player.dash = PlayerHud.player_dash
		player.double_jump = PlayerHud.double_jump
		player.ground_slam = PlayerHud.ground_slam
		player.morph_roll = PlayerHud.morph_roll
	else:
		# set player to the player spawn node position
		player.global_position = self.global_position
		#set all abilities to true
		player.dash = true
		player.double_jump = true
		player.ground_slam = true
		player.morph_roll = true
	pass
