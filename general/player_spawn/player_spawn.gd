@icon("res://general/icons/player_spawn.svg")
class_name PlayerSpawn extends Node2D

var saved_game : SavedGame
var current_scene_uid : String

func _ready() -> void:
	visible = false
	await get_tree().process_frame
	var player = get_tree().get_first_node_in_group( "Player" )
		
	# we do not have a player!
	# instantiate a new instance of our player scene
	if int(owner.name) <= 4:
		player = load("uid://bqkwwrgi782w5").instantiate() # polo

	elif int(owner.name) >= 5:
		player = load("uid://hk8xg8lqmqs5").instantiate() # oren
		
	get_tree().root.add_child( player )
	SaveManager.load_scene( current_scene_uid )
	
	player.global_position = PlayerHud.player_position
	player.hp = PlayerHud.player_hp
	player.cp = PlayerHud.player_cp
	
	player.dash = PlayerHud.player_dash
	player.double_jump = PlayerHud.double_jump
	player.ground_slam = PlayerHud.ground_slam
	player.morph_roll = PlayerHud.morph_roll
	
	pass
