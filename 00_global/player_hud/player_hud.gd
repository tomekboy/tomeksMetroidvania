extends CanvasLayer

@onready var collectable_bar: MarginContainer = %CollectableBar
@onready var cp_bar: TextureProgressBar = $Control/CollectableBar/NinePatchRect/CPBar
@onready var health_bar: MarginContainer = %HealthBar
@onready var hp_bar: TextureProgressBar = $Control/HealthBar/NinePatchRect/HPBar
@onready var game_over: Control = %GameOver
@onready var title_screen_button: Button = %TitleScreenButton

@onready var rhino_awakening : PackedScene = preload("uid://bjveu8w6m1rar")

@onready var boss_hp: Control = %BossHP
@onready var boss_hp_bar: ProgressBar = %BossHPBar
@onready var boss_hp_highlight: ProgressBar = %BossHPHighlight
@onready var boss_name: Label = %BossName
@onready var boss_hp_animation_player: AnimationPlayer = %BossHPAnimationPlayer

@export var audio : AudioStream
@export var controller_rumble : bool = false
@export var rhino_awakening_shown : bool = false
@export var initial_start : bool = false
@export var debug_mode : bool = true

@export var player_position : Vector2 = Vector2.ZERO
@export var player_hp : float = 0
@export var player_cp : float = 0
@export var player_dash : bool = false
@export var double_jump : bool = false
@export var ground_slam : bool = false
@export var morph_roll : bool = false
@export var rhino : bool = false

var boss_hp_tween : Tween

func _ready() -> void:
	# connect to message bus
	MessageManager.player_health_changed.connect( update_health_bar )
	MessageManager.player_collectable_changed.connect( update_collectable_bar )
	boss_hp.visible = false
	game_over.visible = false
	title_screen_button.pressed.connect( _on_title_screen_pressed )
	pass


func update_health_bar( hp: float, max_hp: float ) -> void:
	var value : float = ( hp / max_hp ) * 100
	hp_bar.value = value
pass


func update_collectable_bar( cp: float, max_cp: float ) -> void:
	# check for boss awakening cutscene
	releaseBoss( cp )
	var value : float = ( cp / max_cp ) * 250
	cp_bar.value = value
pass


func show_game_over_screen() -> void:
	title_screen_button.visible = false

	game_over.modulate.a = 0
	game_over.visible = true
	
	var tween : Tween = create_tween()
	tween.tween_property( game_over, "modulate", Color.WHITE, 1.5 )
	AudioManager.play_ui_audio( audio )
	await tween.finished
	
	title_screen_button.visible = true
	
	title_screen_button.grab_focus()
	pass


func clear_game_over_screen() -> void:
	title_screen_button.visible = false
	await SceneManager.scene_entered
	game_over.visible = false
	var player : Player = get_tree().get_first_node_in_group( "Player" )
	player.queue_free()
	pass


func _on_title_screen_pressed() -> void:
	SceneManager.transition_scene( "res://title_screen/title_screen.tscn", "", Vector2.ZERO, "up", false )
	PlayerHud.visible = false
	clear_game_over_screen()
	pass


func releaseBoss( cp : float):
	if  cp >= 2 and !SaveManager.persistent_data.get( "rhino", "0" ) == "defeated" and rhino_awakening_shown == false:
		# 1. Get the current active scene root
		var scene_root = get_tree().current_scene

		# 2. Get the active camera to find where the player is looking
		var camera = get_viewport().get_camera_2d()

		if camera:
			# 3. Calculate the exact world coordinate of the viewport center
			var viewport_center_world = camera.get_screen_center_position()
			
			# 4. Instantiate and configure the rhino
			var rhino_temp = rhino_awakening.instantiate()
			
			# 5. Add to scene root first, then set the GLOBAL position
			scene_root.add_child(rhino_temp)
			rhino_temp.global_position = viewport_center_world
		
		rhino_awakening_shown = true
	else:
		return


func show_boss_hp( _n : String ) -> void:
	boss_hp_bar.value = 1.0
	boss_hp_highlight.value = 1.0
	boss_name.text = _n
	boss_hp_animation_player.play( "show" )
	pass


func update_boss_hp( hp : float, max_hp : float ) ->void:
	var new_value : float = hp /max_hp
	boss_hp_bar.value = new_value
	tween_hp_highlight( new_value )
	pass


func tween_hp_highlight( target_value : float ) -> void:
	if boss_hp_tween:
		boss_hp_tween.kill()
		
	boss_hp_tween = create_tween()
	boss_hp_tween.set_ease( Tween.EASE_OUT )
	boss_hp_tween.set_trans( Tween.TRANS_EXPO )
	boss_hp_tween.tween_interval( 0.5 )
	boss_hp_tween.tween_property( boss_hp_highlight, "value", target_value, 0.5 )
	pass


func hide_boss_hp() -> void:
	boss_hp_animation_player.play( "hide" )
	pass
