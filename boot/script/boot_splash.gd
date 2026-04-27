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
	
	# prepare languageselection for scaling in
	$LanguageSelection.scale = Vector2(0.0, 0.0)
pass


func _on_timer_timeout() -> void:
	$brudMelody.play()
	
	var tween = create_tween()
	# fade out header and logo
	tween.tween_property(%godotLogo, "modulate:a", 0.0, 1.0)
	tween.parallel().tween_property(%Imagination, "modulate:a", 0.0, 1.0)
	
	# fade in language select
	tween.tween_property($LanguageSelection, "modulate:a", 1.0, 1.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
	tween.parallel().tween_property($LanguageSelection, "scale", Vector2.ONE, 1.0)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	
	$swoosh.play()
	pass
