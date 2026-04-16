@icon("res://general/icons/player_spawn.svg")
class_name PlayerSpawn extends Node2D

func _ready() -> void:
	visible = false
	await get_tree().process_frame
	# check to see if we already have a player
	# if we have a player, do nothing
	if get_tree().get_first_node_in_group( "Player" ):
		# we have a player
		return
	# we do not have a player
	# instantiate a new instance of our player
	var player : Player = load( "uid://bqptdqa3mpwhd" ).instantiate()
	get_tree().root.add_child( player )
	# position the player scene
	player.global_position = self.global_position
	pass
