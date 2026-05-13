extends CanvasLayer

signal load_scene_started
signal new_scene_ready( target_name : String, offset : Vector2 )
signal load_scene_finished
signal scene_entered( uid: String )

@onready var fade: Control = $Fade

var current_scene_uid : String
var saved_game : SavedGame

func _ready() -> void:
	fade.visible = false
	await get_tree().process_frame
	load_scene_finished.emit()
	var current_scene : String = get_tree().current_scene.scene_file_path
	current_scene_uid = ResourceUID.path_to_uid( current_scene )
	scene_entered.emit( current_scene_uid )
	pass


func transition_scene( new_scene : String, target_area : String, player_offset : Vector2, dir : String ) -> void:
	# save dynamic objects from scene
	# check for title & boot screen - do not do anythimg
	if not current_scene_uid == "uid://d12hmou2bfva3" and not current_scene_uid == "uid://cwxtcj2bqchg7":
		# save dynamic objects from current_scene (coming from...)
		save_dynamic_objects( current_scene_uid )
	
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
	
	if not current_scene_uid == "uid://d12hmou2bfva3" and not current_scene_uid == "uid://cwxtcj2bqchg7":
		load_dynamic_objects( new_scene )
	
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


func save_dynamic_objects( scene_uid ) -> void:
	saved_game = SavedGame.new()
	# get the dynamic objects
	var saved_data : Array[SavedData] = []
	get_tree().call_group( "DynamicObject", "on_save_game", saved_data )
	saved_game.saved_data = saved_data
	
	# save game data
	ResourceSaver.save( saved_game, "user://0" + str(SaveManager.current_slot + 1) + "_" + scene_uid.substr(6) + ".res" )
	pass


func load_dynamic_objects( scene_uid ) -> void:
	if ResourceLoader.exists( "user://0" + str(SaveManager.current_slot + 1) + "_" + scene_uid.substr(6) + ".res" ):
		saved_game = load( "user://0" + str(SaveManager.current_slot + 1) + "_" + scene_uid.substr(6) + ".res" )
		
		# load dynamic objects
		# resolve the variable scene node number
		# get the uid of current scene and get the path
		var scene_path : String = ResourceUID.uid_to_path(scene_uid)
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
			for entity in saved_game.saved_data:
				var scene = load( entity.scene_path ) as PackedScene
				var restored_node = scene.instantiate()
				dynamic_objects.add_child( restored_node )
				#
				if restored_node.has_method( "on_load_game" ):
					restored_node.on_load_game( entity )
	pass
