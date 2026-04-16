extends Node2D

func _ready() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MINIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	PlayerHud.visible = false
pass


func _on_timer_timeout() -> void:
	SceneManager.transition_scene( "uid://d12hmou2bfva3", "", Vector2.ZERO, "right" )
	pass
	
