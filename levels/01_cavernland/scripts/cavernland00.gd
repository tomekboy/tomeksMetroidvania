extends Node2D

#@onready var saver_loader: SaverLoader = %SaverLoader

@export var BackgroundMusic : AudioStream

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.html("#002223"))
	AudioManager.play_music(BackgroundMusic)
	#saver_loader.load_game()
	#
	GameManager.new_level_reset()
	
	ScoreManager.boss_margin_container.visible = false
	ScoreManager.get_child(0).visible = true
	ScoreManager.note_bar.value = GameManager.game_notes
	ScoreManager.life_bar.value = GameManager.game_lifes
	ScoreManager.boss_bar.value = GameManager.boss_life
	#
	#if get_node_or_null("Boss/Rhino") != null:
		#ScoreManager.show_boss_bar()
	#
	if GameManager.abilities:
		GameManager.game_ability = GameManager.abilities[0]
	pass
