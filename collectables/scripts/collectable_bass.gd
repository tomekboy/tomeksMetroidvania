@icon( "res://general/icons/collectable.svg" )
extends AnimatedSprite2D

const NOTE_SFX = preload("uid://b2xx28ud8iokm")

var amount : float = 5
var collected : bool = false

var cp_pos

func _on_collect_area_body_entered( body: Node2D ) -> void:
	cp_pos = get_viewport_corners()
	AudioManager.play_spatial_sound( NOTE_SFX, global_position )
	VisualEffects.hit_dust( global_position )
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "global_position", cp_pos, .5).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(0, 0), .5).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(queue_free)
	collected = true
	body.cp += amount
	pass


func get_viewport_corners():
	var viewport = get_viewport()
	var canvas_transform = viewport.get_canvas_transform()
	var top_left = canvas_transform.affine_inverse().origin
	return top_left

func on_save_game( saved_data : Array[SavedData] ) -> void:
	# don't do a contract
	if collected:
		return
	# do a contract
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	saved_data.append( my_data )
	pass


func on_before_load_game(  ) -> void:
	get_parent().remove_child( self )
	queue_free()
	pass


func on_load_game( saved_data : SavedData ) -> void:
	global_position = saved_data.position
pass
