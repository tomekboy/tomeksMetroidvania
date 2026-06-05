extends CanvasLayer

signal load_scene_started
signal new_scene_ready( target_name : String, offset : Vector2 )
signal load_scene_finished
signal scene_entered( uid: String )

@onready var fade: Control = $Fade

var current_scene : String
var current_scene_uid : String
var discovered_areas : Array = []
var persistent_data : Dictionary = {}
var saved_game : SavedGame

func _ready() -> void:
	fade.visible = false
	await get_tree().process_frame
	load_scene_finished.emit()
	current_scene = get_tree().current_scene.scene_file_path
	current_scene_uid = ResourceUID.path_to_uid( current_scene )
	scene_entered.emit( current_scene_uid )
	pass


func transition_scene( new_scene : String, target_area : String, player_offset : Vector2, dir : String ) -> void:
	# save dynamic objects from scene
	# check for title & boot screen - do not do anythimg
	if not current_scene_uid == "uid://d12hmou2bfva3" and not current_scene_uid == "uid://cwxtcj2bqchg7":
		# save dynamic objects from current_scene (coming from...)
		SaveManager.save_scene_objects( current_scene_uid )
	
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
		SaveManager.load_scene_objects( new_scene )
	
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
