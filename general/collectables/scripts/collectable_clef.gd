extends AnimatedSprite2D

@onready var ability: TileMapLayer = $"../../../Essentials/TileSets/AbilityPlatform"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GameManager.playSoundFX(load("res://assets/sounds/clef.mp3"))
		ScoreManager.update_note_bar(5)
		GameManager.game_notes += 5
		queue_free()
		ability.enabled = true
	pass
