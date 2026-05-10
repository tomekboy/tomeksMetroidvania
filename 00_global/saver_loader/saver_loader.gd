class_name SaverLoader extends Node

@onready var dynamic_objects: Node = $"../DynamicObjects"
var player = get_tree().get_root().find_child("/Player")

func save_game():
	var saved_game : SavedGame = SavedGame.new()
	# get the player & game values
	#saved_game.player_position = player.global_position
	#saved_game.player_hp = player.hp
	#saved_game.player_max_hp = player.max_hp
	#saved_game.player_cp = player.cp
	#saved_game.player_max_cp = player.max_cp
	#saved_game.player_dash = player.dash
	#saved_game.player_double_jump = player.double_jump
	#saved_game.player_ground_slam = player.ground_slam
	#saved_game.player_morph_roll = player.morph_roll
	saved_game.game_lang = TranslationServer.get_locale()
	saved_game.game_vibration = PlayerHud.controller_rumble
	saved_game.game_discovered_areas = SaveManager.discovered_areas
	

	# get the dynamic objects
	var saved_data : Array[SavedData] = []
	get_tree().call_group( "DynamicObject", "on_save_game", saved_data )
	saved_game.saved_data = saved_data
	
	# save the resource
	ResourceSaver.save( saved_game, "user://savegame.tres" )
	pass


func load_game():
	var saved_game : SavedGame = load( "user://savegame.tres" )
	# load player & game data
	#player.global_position = saved_game.player_position
	# do stuff
	
	# load dynamic objects
	get_tree().call_group( "DynamicObject", "on_before_load_game" )
	
	for entity in saved_game.saved_data:
		var scene = load( entity.scene_path ) as PackedScene
		var restored_node = scene.instantiate()
		##dynamic_objects.add_child( restored_node )
		
		if restored_node.has_method( "on_load_game" ):
			restored_node.on_load_game( entity )
	pass
