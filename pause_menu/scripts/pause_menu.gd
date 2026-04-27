class_name PauseMenu extends CanvasLayer

#region /// onready variables
@onready var pause_screen: Control = %PauseScreen
@onready var system: Control = %System

@onready var system_menu_button: Button = %SystemMenuButton

@onready var back_to_map_button: Button = %BackToMapButton
@onready var back_to_title_button: Button = %BackToTitleButton

@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
@onready var screen_check_button: CheckButton = %ScreenCheckButton

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
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		screen_check_button.button_pressed = true
	else:
		screen_check_button.button_pressed = false
	pass


func  _on_back_to_title_pressed() -> void:
	SceneManager.transition_scene( "res://title_screen/title_screen.tscn", "", Vector2.ZERO, "up" )
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
	pass
