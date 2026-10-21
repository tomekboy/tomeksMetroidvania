class_name RHThrow extends EnemyState

@export var attack_area : AttackArea
@export var attack_range : float = 400
@export var move_speed : float = 75
@export var cooldown : float = 1.0

var timer : float = 0
var duration : float = 0
var on_cooldown : bool = false

func enter() -> void:
	if blackboard.target:
		var dir : float = sign( blackboard.target.global_position.x - enemy.global_position.x )
		enemy.change_dir( dir )
		
	enemy.play_animation( animation_name if animation_name else "throw" )
	duration = enemy.animation.current_animation_length
	timer = 0
	blackboard.can_decide = false
	on_cooldown = true
	enemy.velocity.x = move_speed * blackboard.dir
	if attack_area:
		attack_area.flip( blackboard.dir )
	pass


func re_enter() -> void:
	# What happens if the state is called again?
	pass


func exit() -> void:
	blackboard.can_decide = true
	run_cooldown()
	pass


func physics_update( _delta : float ) -> void:
	timer += _delta
	if timer >= duration:
		blackboard.can_decide = true
	pass


func can_attack() -> bool:
	var player : Player = get_tree().get_first_node_in_group( "Player" )
	if player and not on_cooldown:
		var distance: float = player.global_position.distance_to(enemy.global_position)
		if distance >= 299.0 and distance <= 300.0:
			return true
	return false


func run_cooldown() -> void:
	await get_tree().create_timer( cooldown ).timeout
	on_cooldown = false
	pass
	
