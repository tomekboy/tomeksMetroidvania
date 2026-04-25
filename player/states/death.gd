class_name PlayerStateDeath extends PlayerState

const DEATH_SFX = preload("uid://dvibfaw5tbft0")

# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play( "die" )
	AudioManager.play_spatial_sound( DEATH_SFX, player.global_position, true )
	AudioManager.play_music( null )
	await player.animation_player.animation_finished
	PlayerHud.show_game_over_screen()
	pass


# what happens each physics process tick in this state?
func physics_process( _delta: float ) -> PlayerState:
	player.velocity.x = 0
	return null
