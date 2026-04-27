extends CanvasLayer

#region /// on ready variables
@onready var main_menu: VBoxContainer = %MainMenu
@onready var new_game_menu: Panel = $NewGameMenu
@onready var load_game_menu: Panel = $LoadGameMenu
@onready var settings_game_menu: Control = %SettingsGameMenu

# buttons
@onready var new_game_button: Button = %NewGameButton
@onready var load_game_button: Button = %LoadGameButton
@onready var settings_game_button: Button = %SettingsGameButton
@onready var exit_game_button: Button = %ExitGameButton

@onready var new_slot_1: Button = %NewSlot1
@onready var new_slot_2: Button = %NewSlot2
@onready var new_slot_3: Button = %NewSlot3

@onready var load_slot_1: Button = %LoadSlot1
@onready var load_slot_2: Button = %LoadSlot2
@onready var load_slot_3: Button = %LoadSlot3

# slider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider

@onready var screen_check_button: CheckButton = %ScreenCheckButton

@onready var hello: VideoStreamPlayer = %Hello
#endregion

const TEST_SOUND = preload("uid://c2s8ms1y15lvw") # freesound_community-positive-response-81640

func _ready() -> void:
	# connect to button signals
	new_game_button.pressed.connect( show_new_game_menu )
	load_game_button.pressed.connect( show_load_game_menu )
	settings_game_button.pressed.connect( show_settings_game_menu )
	exit_game_button.pressed.connect( exit_game )
	
	new_slot_1.pressed.connect( _on_new_game_pressed.bind( 0 ) )
	new_slot_2.pressed.connect( _on_new_game_pressed.bind( 1 ) )
	new_slot_3.pressed.connect( _on_new_game_pressed.bind( 2 ) )
	
	load_slot_1.pressed.connect( _on_load_game_pressed.bind( 0 ) )
	load_slot_2.pressed.connect( _on_load_game_pressed.bind( 1 ) )
	load_slot_3.pressed.connect( _on_load_game_pressed.bind( 2 ) )
	
	music_slider.value = AudioServer.get_bus_volume_linear( 2 )
	sfx_slider.value = AudioServer.get_bus_volume_linear( 3 )
	ui_slider.value = AudioServer.get_bus_volume_linear( 4 )
	
	music_slider.value_changed.connect( _on_music_slider_changed )
	sfx_slider.value_changed.connect( _on_sfx_slider_changed )
	ui_slider.value_changed.connect( _on_ui_slider_changed )
	screen_check_button.toggled.connect( _on_screen_check_button_changed )
		
	# add audio
	AudioManager.setup_button_audio( self )
	
	# set display slider
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		screen_check_button.button_pressed = true
	else:
		screen_check_button.button_pressed = false
	pass
	
	# show main menu
	show_main_menu()
	
	# play welcome video
	hello.paused = false
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed( "ui_cancel" ):
		if main_menu.visible == false:
			#audio
			AudioManager.ui_cancel()
			show_main_menu()
	pass


func show_main_menu() -> void:
	main_menu.visible = true
	new_game_menu.visible = false
	load_game_menu.visible = false
	settings_game_menu.visible = false
	# focus
	new_game_button.grab_focus()
	pass


func show_new_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = true
	load_game_menu.visible = false
	# focus
	new_slot_1.grab_focus()
	
	if SaveManager.save_file_exists( 0 ):
		new_slot_1.text = "ersetze Spiel 01"
		
	if SaveManager.save_file_exists( 1 ):
		new_slot_2.text = "ersetze Spiel 02"
		
	if SaveManager.save_file_exists( 2 ):
		new_slot_3.text = "ersetze Spiel 03"
	pass


func show_load_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = false
	load_game_menu.visible = true
	# check whether saved game available
	load_slot_1.disabled = not SaveManager.save_file_exists( 0 )
	load_slot_2.disabled = not SaveManager.save_file_exists( 1 )
	load_slot_3.disabled = not SaveManager.save_file_exists( 2 )
	# set focus
	if !load_slot_1.disabled:
		load_slot_1.grab_focus()
	elif !load_slot_2.disabled:
		load_slot_2.grab_focus()
	elif !load_slot_3.disabled:
		load_slot_3.grab_focus()
	pass


func _on_new_game_pressed( slot : int ) -> void:
	SaveManager.create_new_game_save( slot )
	pass


func _on_load_game_pressed( slot : int ) -> void:
	SaveManager.load_game( slot )
	pass


func show_settings_game_menu() -> void:
	main_menu.visible = false
	settings_game_menu.visible = true
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
	print( "display toggle" )
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	pass


func exit_game() -> void:
	AudioManager.ui_quit()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
	pass
