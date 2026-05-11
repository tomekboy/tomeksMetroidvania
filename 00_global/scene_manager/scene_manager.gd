extends CanvasLayer

signal load_scene_started
signal new_scene_ready( target_name : String, offset : Vector2 )
signal load_scene_finished
signal scene_entered( uid: String )

@onready var fade: Control = $Fade

var current_scene_uid : String

func _ready() -> void:
	fade.visible = false
	await get_tree().process_frame
	load_scene_finished.emit()
	var current_scene : String = get_tree().current_scene.scene_file_path
	current_scene_uid = ResourceUID.path_to_uid( current_scene )
	scene_entered.emit( current_scene_uid )
	pass


func transition_scene( new_scene : String, target_area : String, player_offset : Vector2, dir : String ) -> void:

	# ignore the 2 title screens nothing to save
	if not current_scene_uid == "uid://d12hmou2bfva3" and not current_scene_uid == "uid://cwxtcj2bqchg7" :
		# save or load the resource data if available
		if ResourceLoader.exists( "user://0" + str( SaveManager.current_slot + 1 ) + "_" + current_scene_uid.substr(6) + ".res") :
			# ResourceLoader.load( "user://0" + str( SaveManager.current_slot + 1 ) + "_" + current_scene_uid.substr(6) + ".res" )
			SaveManager.saved_game = load( "user://0" + str( SaveManager.current_slot + 1 ) + "_" + current_scene_uid.substr(6) + ".res" )
		else:
			var player : Player = get_tree().get_first_node_in_group( "Player" )
			
			SaveManager.saved_game = SavedGame.new()
			SaveManager.saved_game.scene_path = SceneManager.current_scene_uid
			# get the player & game values
			SaveManager.saved_game.player_position = player.global_position
			SaveManager.saved_game.player_hp = player.hp
			SaveManager.saved_game.player_max_hp = player.max_hp
			SaveManager.saved_game.player_cp = player.cp
			SaveManager.saved_game.player_max_cp = player.max_cp
			SaveManager.saved_game.player_dash = player.dash
			SaveManager.saved_game.player_double_jump = player.double_jump
			SaveManager.saved_game.player_ground_slam = player.ground_slam
			SaveManager.saved_game.player_morph_roll = player.morph_roll
			SaveManager.saved_game.game_discovered_areas = SaveManager.discovered_areas
			

			# get the dynamic objects
			var saved_data : Array[SavedData] = []
			get_tree().call_group( "DynamicObject", "on_save_game", saved_data )
			SaveManager.saved_game.saved_data = saved_data
			ResourceSaver.save( SaveManager.saved_game, "user://0" + str( SaveManager.current_slot + 1 ) + "_" + current_scene_uid.substr(6) + ".res")
		
	get_tree().paused = true
	
	var fade_pos : Vector2 = get_fade_pos( dir )
	
	fade.visible = true
	
	load_scene_started.emit()
	
	await fade_screen( fade_pos, Vector2.ZERO )
	
	get_tree().change_scene_to_file( new_scene )
	current_scene_uid = ResourceUID.path_to_uid( new_scene )
	scene_entered.emit( current_scene_uid )
	
	await get_tree().scene_changed
	
	new_scene_ready.emit( target_area, player_offset )
	
	await get_tree().process_frame
	await fade_screen( Vector2.ZERO, -fade_pos )
	
	fade.visible = false
	get_tree().paused = false
	load_scene_finished.emit()
	pass


func fade_screen( from: Vector2, to : Vector2 ) -> Signal:
	fade.position = from
	var tween : Tween = create_tween()
	tween.tween_property( fade, "position", to, 0.2 )
	return tween.finished


func get_fade_pos( direction : String ) -> Vector2:
	var pos : Vector2 = Vector2( 1040 * 2, 640 * 2 )
	match direction:
		"left":
			pos *= Vector2( -1, 0 )
		"right":
			pos *= Vector2( 1, 0 )
		"up":
			pos *= Vector2( 0, -1 )
		"down":
			pos *= Vector2( 0, 1 )
	return pos
