extends CanvasLayer

#region /// on ready variables
@onready var main_menu: VBoxContainer = %MainMenu
@onready var new_game_menu: Panel = $NewGameMenu
@onready var load_game_menu: Panel = $LoadGameMenu

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

#endregion

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
	
	# add audio
	AudioManager.setup_button_audio( self )
	
	# show main menu
	show_main_menu()
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed( "ui_cancel" ):
		if main_menu.visible == false:
			#audio
			show_main_menu()
	pass


func show_main_menu() -> void:
	main_menu.visible = true
	new_game_menu.visible = false
	load_game_menu.visible = false
	# focus
	new_game_button.grab_focus()
	pass


func show_new_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = true
	load_game_menu.visible = false
	#focus
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
	print( "show settings menu" )
	get_tree().paused = true
	var pause_menu : PauseMenu = load( "res://pause_menu/pause_menu.tscn" ).instantiate()
	add_child( pause_menu )
	
	pause_menu.pause_screen.visible = false
	pause_menu.system.visible = true
	pass


func exit_game() -> void:
	AudioManager.ui_quit()
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
