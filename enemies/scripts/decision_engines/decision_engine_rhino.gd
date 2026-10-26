class_name DecisionEngineRhino extends DecisionEngine

@onready var rh_attack: RHAttack = %RHAttack
@onready var rh_death: RHDeath = %RHDeath
@onready var rh_jump_whack: RHJumpWhack = %RHJumpWhack
@onready var rh_punch: RHPunch = %RHPunch
@onready var rh_shockwave: RHShockwave = %RHShockwave
@onready var rh_stab: RHStab = %RHStab
@onready var rh_stun: RHStun = %RHStun
@onready var rh_throw: RHThrow = %RHThrow
@onready var rh_walk: RHWalk = %RHWalk
@onready var rh_whack: RHWhack = %RHWhack

# --- COMBO TRACKING VARIABLES ---
@export var combo_time_limit: float = 12.0  # Time window (in seconds) to count hits as "successive"
var successive_hit_count: int = 0
@onready var combo_timer: Timer = Timer.new()
# --------------------------------

func _ready() -> void:
	await super() # Maintains important setup code & timing
	
	# Dynamically set up the combo window timer
	add_child(combo_timer)
	combo_timer.one_shot = true
	combo_timer.wait_time = combo_time_limit
	combo_timer.timeout.connect(_on_combo_timer_timeout)
	
	pass


# All the conditions for making decisions go in this function
func decide() -> EnemyState:

	if enemy.is_on_wall():
		blackboard.target = null
		return
		
	if blackboard.damage_source:
		if blackboard.health <= 0:
			return rh_death
		else:
			if not combo_timer.is_stopped():
				successive_hit_count += 1
			else:
				successive_hit_count = 1
			combo_timer.start()
			
			if successive_hit_count >= 3:
				return handle_three_successive_hits()
			return rh_stun

	if current_state is ESDeath or not blackboard.can_decide:
		return null
	
	if rh_shockwave.can_attack() and blackboard.health == 3:
		return rh_shockwave
	
	if  rh_throw.can_attack() and blackboard.health <= 10:
		return rh_throw

	if blackboard.target:

		if  rh_stab.can_attack():
			blackboard.executed_attacks += 1
			return rh_stab
				
		if  rh_whack.can_attack():
			blackboard.executed_attacks += 1
			return rh_whack
				
		if  rh_punch.can_attack():
			blackboard.executed_attacks += 1
			return rh_punch
			
	return rh_walk


func _on_combo_timer_timeout() -> void:
	successive_hit_count = 0
	pass


func handle_three_successive_hits() -> EnemyState:
	successive_hit_count = 0
	combo_timer.stop()
	blackboard.damage_source = null
	rh_jump_whack.on_cooldown = false 
	return rh_jump_whack
