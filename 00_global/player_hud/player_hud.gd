extends CanvasLayer

@export var audio : AudioStream
@onready var hp_margin_container: MarginContainer = %HPMarginContainer
@onready var hp_bar: TextureProgressBar = %HPBar

@onready var game_over: Control = %GameOver
@onready var load_button: Button = %LoadButton
@onready var title_screen_button: Button = %TitleScreenButton

func _ready() -> void:
	# connect to message bus
	MessageManager.player_health_changed.connect( update_health_bar )
	
	game_over.visible = false
	load_button.pressed.connect( _on_load_pressed )
	title_screen_button.pressed.connect( _on_title_screen_pressed )
	pass


func update_health_bar( hp: float, max_hp: float ) -> void:
	var value : float = ( hp / max_hp ) * 100
	hp_bar.value = value
	hp_margin_container.size.x = max_hp + 22
pass


func show_game_over_screen() -> void:
	load_button.visible = false
	title_screen_button.visible = false

	game_over.modulate.a = 0
	game_over.visible = true
	
	var tween : Tween = create_tween()
	tween.tween_property( game_over, "modulate", Color.WHITE, 1.5 )
	AudioManager.play_ui_audio( audio )
	await tween.finished
	
	load_button.visible = true
	title_screen_button.visible = true
	
	load_button.grab_focus()
	pass


func clear_game_over_screen() -> void:
	load_button.visible = false
	title_screen_button.visible = false
	await SceneManager.scene_entered
	game_over.visible = false
	var player : Player = get_tree().get_first_node_in_group( "Player" )
	player.queue_free()
	pass


func _on_load_pressed () -> void:
	SaveManager.load_game( SaveManager.current_slot )
	# clear game over screen
	clear_game_over_screen()
	pass


func _on_title_screen_pressed() -> void:
	SceneManager.transition_scene( "res://title_screen/title_screen.tscn", "", Vector2.ZERO, "up" )
	# clear game over screen
	clear_game_over_screen()
	pass
