@tool
@icon( "res://general/icons/level_bounds.svg" )
class_name LevelBounds extends Node2D

@export_range( 1020, 4080, 16, "suffix:px" ) var width : int = 1020 : set = _on_width_changed
@export_range( 640, 4080, 16, "suffix:px" ) var height : int = 640 : set = _on_height_changed

func _ready() -> void:
	# handle z-index
	z_index = 256
	# check for and get reference to our camera
	if Engine.is_editor_hint():
		return
	var camera : Camera2D = null
	while not camera:
		await get_tree().process_frame
		camera = get_viewport().get_camera_2d()
	# update camera's limits
	camera.limit_left = int( global_position.x )
	camera.limit_top = int( global_position.y )
	camera.limit_right = int( global_position.x ) + width
	camera.limit_bottom = int( global_position.y ) + height
	pass


func _draw() -> void:
	if Engine.is_editor_hint():
		# draw a rectangle
		var r : Rect2 = Rect2( Vector2.ZERO, Vector2( width, height ) )
		draw_rect( r, Color( 0.0, 0.45, 1.0, 0.6 ), false, 6 )
		draw_rect( r, Color( 0.0, 0.75, 1.0 ), false, 3 )
	pass


func _on_width_changed( new_width : int ) -> void:
	width = new_width
	queue_redraw()
	pass


func _on_height_changed( new_height : int ) -> void:
	height = new_height
	queue_redraw()
	pass
