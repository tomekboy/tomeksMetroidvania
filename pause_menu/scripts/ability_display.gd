extends Node

@onready var ability_double_jump: TextureRect = %AbilityDoubleJump
@onready var ability_dash: TextureRect = %AbilityDash

@onready var ability_slam: TextureRect = %AbilitySlam
@onready var ability_roll: TextureRect = %AbilityRoll

func _ready() -> void:
	var player : Player = get_tree().get_first_node_in_group( "Player" )
	ability_dash.visible = player.dash
	ability_double_jump.visible = player.double_jump
	ability_slam.visible = player.ground_slam
	ability_roll.visible = player.morph_roll
	pass
