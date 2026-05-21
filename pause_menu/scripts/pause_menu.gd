class_name PauseMenu extends CanvasLayer

#region /// onready variables
@onready var pause_screen: Control = %PauseScreen
@onready var system: Control = %System

@onready var system_menu_button: Button = %SettingsMenuButton

@onready var back_to_map_button: Button = %BackToMapButton
@onready var back_to_title_button: Button = %BackToTitleButton

@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
@onready var screen_check_button: CheckButton = %ScreenCheckButton
@onready var rumble_check_button: CheckButton = $Control/System/MiscSettings/HBoxContainerController/RumbleCheckButton

@onready var story: Control = %StoryScreen
@onready var story_back_button: Button = $Control/StoryScreen/StoryBackButton
@onready var character_cast: ItemList = $Control/StoryScreen/CharacterCast
@onready var character_vita: RichTextLabel = $Control/StoryScreen/CharacterVita

#endregion

const TEST_SOUND = preload("uid://c2s8ms1y15lvw") # freesound_community-positive-response-81640

var player_position : Vector2

func _ready() -> void:
	show_pause_screen()
	PlayerHud.visible = false
	system_menu_button.pressed.connect( show_system_menu )
	# audio
	AudioManager.setup_button_audio( self )
	# setup system
	setup_system_menu()
	# get player for spatial position
	var player : Node2D = get_tree().get_first_node_in_group( "Player ")
	if player:
		player_position = player.global_position
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed( "pause" ):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
		if get_tree().get_root().has_node("Player"):
			PlayerHud.visible = true
	if pause_screen.visible == true:
		if event.is_action_pressed( "right" ) or event.is_action_pressed( "down" ):
			system_menu_button.grab_focus()
	pass


func show_pause_screen() -> void:
	pause_screen.visible = true
	system.visible = false
	story.visible = false
	system_menu_button.grab_focus()
	pass


func show_system_menu() -> void:
	pause_screen.visible = false
	system.visible = true
	back_to_map_button.grab_focus()
	pass


func setup_system_menu() -> void:
	#setup the sliders
	music_slider.value = AudioServer.get_bus_volume_linear( 2 )
	sfx_slider.value = AudioServer.get_bus_volume_linear( 3 )
	ui_slider.value = AudioServer.get_bus_volume_linear( 4 )
	
	music_slider.value_changed.connect( _on_music_slider_changed )
	sfx_slider.value_changed.connect( _on_sfx_slider_changed )
	ui_slider.value_changed.connect( _on_ui_slider_changed )
		
	back_to_title_button.pressed.connect( _on_back_to_title_pressed )
	back_to_map_button.pressed.connect( show_pause_screen )
	screen_check_button.toggled.connect( _on_screen_check_button_changed )
	rumble_check_button.toggled.connect( _on_rumble_check_button_changed )
	
	story_back_button.pressed.connect( show_pause_screen )
	
	if PlayerHud.controller_rumble:
		rumble_check_button.button_pressed = true
	else:
		screen_check_button.button_pressed = false
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		screen_check_button.button_pressed = true
	else:
		screen_check_button.button_pressed = false
	pass


func  _on_back_to_title_pressed() -> void:
	SceneManager.transition_scene( "res://title_screen/title_screen.tscn", "", Vector2.ZERO, "down" )
	get_tree().paused = false
	MessageManager.back_to_title_screen.emit()
	queue_free()
	pass


func _on_music_slider_changed( v : float ) -> void:
	AudioServer.set_bus_volume_linear( 2, v )
	# save to settings
	SaveManager.save_configuration()
	pass


func _on_sfx_slider_changed( v : float ) -> void:
	AudioServer.set_bus_volume_linear( 3, v )
	AudioManager.play_spatial_sound( TEST_SOUND, Vector2.ZERO )
	# save to settings
	SaveManager.save_configuration()
	pass


func _on_ui_slider_changed( v : float ) -> void:
	AudioServer.set_bus_volume_linear( 4, v )
	AudioManager.play_ui_audio( TEST_SOUND )
	# save to settings
	SaveManager.save_configuration()
	pass


func _on_screen_check_button_changed( toggled_on : bool ) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	# save to settings
	SaveManager.save_configuration()
	pass


func _on_rumble_check_button_changed( toggled_on : bool ) -> void:
	if toggled_on:
		PlayerHud.controller_rumble = true
	else:
		PlayerHud.controller_rumble = false
	# save to settings
	SaveManager.save_configuration()
	pass


func _on_language_option_button_item_selected( _index: int ) -> void:
	SaveManager.save_configuration()
	pass


func _on_settings_story_button_pressed() -> void:
	var active_player = get_tree().get_first_node_in_group( "Player" )
	if active_player.name == "Polo":
		character_cast.select( 0 )
		character_vita.text = tr( "characterVita" )
	elif active_player.name  == "Clukr":
		character_cast.select( 1 )
		character_vita.text = tr( "characterVitaClukr" )
	elif active_player.name  == "funBot":
		character_cast.select( 2 )
		character_vita.text = tr( "characterVitaFunBot" )
	elif active_player.name  == "Oren":
		character_cast.select( 3 )
		character_vita.text = tr( "characterVitaOren" )
	elif active_player.name  == "Raddy":
		character_cast.select( 4 )
		character_vita.text = tr( "characterVitaRaddy" )
	elif active_player.name  == "Vineria":
		character_cast.select( 5 )
		character_vita.text = tr( "characterVitaVineria" )
	
	character_cast.ensure_current_is_visible()
	
	pause_screen.visible = false
	system.visible = false
	story.visible = true
	story_back_button.grab_focus()
	pass


func _on_back_to_map_button_pressed() -> void:
	show_pause_screen()
	pass


func _on_character_cast_item_selected( index: int ) -> void:
	if index == 0:
		character_vita.text = tr( "characterVita" )
	elif index == 1:
		character_vita.text = tr( "characterVitaClukr" )
	elif index == 2:
		character_vita.text = tr( "characterVitaFunBot" )
	elif index == 3:
		character_vita.text = tr( "characterVitaOren" )
	elif index == 4:
		character_vita.text = tr( "characterVitaRaddy" )
	elif index == 5:
		character_vita.text = tr( "characterVitaVineria" )
	else:
		character_vita.text = "something went wrong ..."
	pass
