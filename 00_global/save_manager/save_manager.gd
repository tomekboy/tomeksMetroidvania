extends Node

const SLOTS : Array[ String ] = [
	"01", "02", "03"
]

var current_slot : int = 0
var discovered_areas : Array = []
var saved_game : SavedGame

func _ready() -> void:
	load_configuration()
	SceneManager.scene_entered.connect( _on_scene_entered )
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F5:
			save_game()
		elif event.keycode == KEY_F7:
			load_game( current_slot )
		elif event.keycode == KEY_1:
			current_slot = 0
		elif event.keycode == KEY_2:
			current_slot = 1
		elif event.keycode == KEY_3:
			current_slot = 2
	pass


func create_new_game_save( slot : int ) -> void:
	current_slot = slot
	discovered_areas.clear()
	var new_game_scene : String = "uid://cfiuv8loi78a5" # 00_wonderland/01.tsn
	discovered_areas.append( new_game_scene )
	# set default values
	saved_game = SavedGame.new()
	saved_game.scene_path = SceneManager.current_scene_uid
	saved_game.player_position = Vector2(1610,120)
	saved_game.player_hp = 10
	saved_game.player_max_hp = 20
	saved_game.player_cp = 0
	saved_game.player_max_cp = 250
	saved_game.player_dash = false
	saved_game.player_double_jump = false
	saved_game.player_ground_slam = false
	saved_game.player_morph_roll = false
	saved_game.game_discovered_areas = discovered_areas
	
	#initialize first scene
	SceneManager.transition_scene( new_game_scene, "", Vector2.ZERO, "up" )
	await SceneManager.new_scene_ready
	
	# get the initial game values
	load_configuration()
	
	# setup player
	var player : Player = null
	while not player:
		player = get_tree().get_first_node_in_group( "Player" )
		await get_tree().process_frame
	
	player.global_position = saved_game.player_position
	player.hp = saved_game.player_hp
	player.max_hp = saved_game.player_max_hp
	player.cp = saved_game.player_cp
	player.max_cp = saved_game.player_max_cp
	player.dash = saved_game.player_dash
	player.double_jump = saved_game.player_double_jump
	player.ground_slam = saved_game.player_ground_slam
	player.morph_roll = saved_game.player_morph_roll

	discovered_areas = saved_game.game_discovered_areas
	
	# show player hud
	PlayerHud.visible = true
	
	# get the dynamic objects
	var saved_data : Array[SavedData] = []
	get_tree().call_group( "DynamicObject", "on_save_game", saved_data )
	saved_game.saved_data = saved_data
	
	# save game data
	ResourceSaver.save( saved_game, get_file_name( current_slot ) )
pass


func save_game():
	var player : Player = get_tree().get_first_node_in_group( "Player" )
	
	saved_game = SavedGame.new()
	saved_game.scene_path = SceneManager.current_scene_uid
	# get the player & game values
	saved_game.player_position = player.global_position
	saved_game.player_hp = player.hp
	saved_game.player_max_hp = player.max_hp
	saved_game.player_cp = player.cp
	saved_game.player_max_cp = player.max_cp
	saved_game.player_dash = player.dash
	saved_game.player_double_jump = player.double_jump
	saved_game.player_ground_slam = player.ground_slam
	saved_game.player_morph_roll = player.morph_roll
	saved_game.game_discovered_areas = discovered_areas
	

	# get the dynamic objects
	var saved_data : Array[SavedData] = []
	get_tree().call_group( "DynamicObject", "on_save_game", saved_data )
	saved_game.saved_data = saved_data
	
	# save game data
	ResourceSaver.save( saved_game, get_file_name( current_slot ) )
	pass


func load_game( slot : int ) -> void:
	# called from title screen
	saved_game = load( get_file_name( slot ) )
	
	if saved_game.scene_path == "uid://d12hmou2bfva3" :
		saved_game.scene_path = saved_game.game_discovered_areas[0]
	SceneManager.transition_scene( saved_game.scene_path, "", Vector2.ZERO, "up" )
	await SceneManager.new_scene_ready
	
	# get the initial game settings
	load_configuration()
	
	# setup player
	var player : Player = null
	while not player:
		player = get_tree().get_first_node_in_group( "Player" )
		await get_tree().process_frame
	# get game values
	player.global_position = saved_game.player_position
	player.hp = saved_game.player_hp
	player.max_hp = saved_game.player_max_hp
	player.cp = saved_game.player_cp
	player.max_cp = saved_game.player_max_cp
	player.dash = saved_game.player_dash
	player.double_jump = saved_game.player_double_jump
	player.ground_slam = saved_game.player_ground_slam
	player.morph_roll = saved_game.player_morph_roll
	discovered_areas = saved_game.game_discovered_areas
	
	# load dynamic objects
	# resolve the variable scene node number
	# get the uid of current scene and get the path
	var scene_path : String = ResourceUID.uid_to_path(SceneManager.current_scene_uid)
	# extract last 7 characters as they are always the same but scene number
	var level_tscn : String = scene_path.right( 7 )
	# extract the scene number only
	var level : String = level_tscn.substr( 0, 2 )
	# define dynamic_objects for getting the node
	var dyn_obj_path : String = "../" + level + "/DynamicObjects"
	# define dynamic_objects
	var dynamic_objects = get_node_or_null( dyn_obj_path )
	
	if dynamic_objects:
		get_tree().call_group( "DynamicObject", "on_before_load_game" )
		
		if saved_game.scene_path == "uid://d12hmou2bfva3": # start screen
			return
		else:
			for entity in saved_game.saved_data:
				var scene = load( entity.scene_path ) as PackedScene
				var restored_node = scene.instantiate()
				dynamic_objects.add_child( restored_node )
				
				if restored_node.has_method( "on_load_game" ):
					restored_node.on_load_game( entity )
	# show player hud
	PlayerHud.visible = true
	pass


func get_file_name( slot : int ) -> String:
	return "user://" + SLOTS[ slot ] + ".res"


func save_file_exists( slot : int ) -> bool:
	# called from title screen
	return FileAccess.file_exists( get_file_name( slot ) )


func is_area_discovered( scene_uid : String ) -> bool:
	return discovered_areas.has( scene_uid )


func _on_scene_entered( scene_uid : String ) -> void:
	if discovered_areas.has( scene_uid ):
		return
	else:
		discovered_areas.append( scene_uid )
	pass

#region /// configuration settings

func save_configuration() -> void:
	var config := ConfigFile.new()
	config.set_value( "audio", "music", AudioServer.get_bus_volume_linear( 2 ) )
	config.set_value( "audio", "sfx", AudioServer.get_bus_volume_linear( 3 ) )
	config.set_value( "audio", "ui", AudioServer.get_bus_volume_linear( 4 ) )
	config.set_value( "game", "screen", DisplayServer.window_get_mode() )
	config.set_value( "game", "controller", PlayerHud.controller_rumble )
	config.set_value( "game", "language", TranslationServer.get_locale() )
	
	config.save( "user://0"  + str( current_slot + 1 ) + ".cfg" )
	pass


func load_configuration() -> void:
	var config := ConfigFile.new()
	var err = config.load( "user://0"  + str( current_slot + 1 ) + ".cfg" )

	if err != OK:
		AudioServer.set_bus_volume_linear( 2, 0.099999994 )
		AudioServer.set_bus_volume_linear( 3, 0.65 )
		AudioServer.set_bus_volume_linear( 4, 0.29999998 )
		# save settings as default
		config.set_value( "audio", "music", AudioServer.get_bus_volume_linear( 2 ) )
		config.set_value( "audio", "sfx", AudioServer.get_bus_volume_linear( 3 ) )
		config.set_value( "audio", "ui", AudioServer.get_bus_volume_linear( 4 ) )
		config.save( "user://00.cfg" )
		return
	
	AudioServer.set_bus_volume_linear( 2, config.get_value( "audio", "music", 0.8 ) )
	AudioServer.set_bus_volume_linear( 3, config.get_value( "audio", "sfx", 1.0 ) )
	AudioServer.set_bus_volume_linear( 4, config.get_value( "audio", "ui", 1.0 ) )
	DisplayServer.window_set_mode( config.get_value( "game", "screen", 0 ) )
	PlayerHud.controller_rumble = config.get_value( "game", "controller", false )
	TranslationServer.set_locale( config.get_value( "game", "language", TranslationServer.get_locale() ) )
	pass

#endregion
