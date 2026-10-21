class_name DecisionEngineRhino extends DecisionEngine

@onready var rh_attack: RHAttack = %RHAttack
@onready var rh_death: RHDeath = %RHDeath
@onready var rh_jump_whack: RHJumpWhack = %RHJumpWhack
@onready var rh_punch: RHPunch = %RHPunch
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
			# --- INTEGRATION BEFORE RETURN STUN ---
		
			# 1. Check if the combo timer is active. 
			# If it stopped running, the gap between hits was too long, so reset.
			if not combo_timer.is_stopped():
				successive_hit_count += 1
			else:
				successive_hit_count = 1 # Start of a new rapid succession
			
			# 2. Refresh/Start the timer window for the NEXT hit
			combo_timer.start()
			
			# 3. Evaluate if the succession threshold is hit
			if successive_hit_count >= 3:
				return handle_three_successive_hits()
			
			# Otherwise, proceed with normal stun
			return rh_stun
			# --------------------------------------

	if current_state is ESDeath or not blackboard.can_decide:
		return null
		
	if  rh_throw.can_attack():
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
	# The player took too long to hit the Rhino again, break the succession chain
	successive_hit_count = 0


func handle_three_successive_hits() -> EnemyState:
	# 1. Reset the counters completely
	successive_hit_count = 0
	combo_timer.stop()
	
	# 2. CRITICAL: Wipe out the damage tracking variables so 
	# decide() skips the damage check entirely on the next frame.
	blackboard.damage_source = null

	# 3. Bypass cooldown constraints
	rh_jump_whack.on_cooldown = false 
	
	return rh_jump_whack
