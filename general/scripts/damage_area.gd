@icon( "res://general/icons/damage_area.svg" )
class_name DamageArea extends Area2D

signal damage_taken( attack_area )

@export var enemy_state_machine: Node = null
@export var audio : AudioStream 

func take_damage( a : AttackArea ) -> void:
	var attacker = a.owner if a.owner else a.get_parent()
	if attacker == null:
		return

	if enemy_state_machine != null:
		if attacker.is_in_group("Player"):
			if enemy_state_machine.current_state is RHJumpWhack:
				return
		elif attacker.is_in_group("Enemy"):
			return

	damage_taken.emit( a )
	if audio:
		AudioManager.play_spatial_sound( audio, global_position)
	pass


func make_invulnerable( duration : float = 1.0 ) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer( duration ).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
	pass


func start_invulnerable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass


func end_invulnerable() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	pass
