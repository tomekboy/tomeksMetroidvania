extends Node2D

@onready var godot_logo: Sprite2D = %godotLogo
@onready var imagination: Label = %Imagination

func _ready() -> void:
	# check for language
	var language = "automatic"
	# Load here language from the user settings file
	if language == "automatic":
		var preferred_language = OS.get_locale_language()
		TranslationServer.set_locale(preferred_language)
	else:
		TranslationServer.set_locale(language)
	
	# check for display setting
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MINIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	# initialize player HUD
	PlayerHud.visible = false
	
	# let the earth rotate
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property($Earth, "rotation", rotation + PI * 2, 120.0).as_relative()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	pass


func _on_timer_timeout() -> void:
	SceneManager.transition_scene( "uid://d12hmou2bfva3", "", Vector2.ZERO, "right" )
	pass
