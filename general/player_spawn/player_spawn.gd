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
	print( owner.name )
	# instantiate a new instance of our player
	

	#var player : Player = load( "uid://bigvkd21y7h7o" ).instantiate() # clukr
	#var player : Player = load( "uid://tv745ppshr4h" ).instantiate() # funBot
	#var player : Player = load( "uid://bqkwwrgi782w5" ).instantiate() # polo
	#var player : Player = load( "uid://hk8xg8lqmqs5" ).instantiate() # oren
	var player : Player = load( "uid://rxde3cqs6i6v" ).instantiate() # raddy
	#var player : Player = load( "uid://t4wj30fmmhcc" ).instantiate() # vineria

	get_tree().root.add_child( player )
	# position the player scene
	player.global_position = self.global_position
	pass


func get_player() -> void:
	
	pass
