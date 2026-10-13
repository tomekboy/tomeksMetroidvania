class_name DecisionEngineRhino extends DecisionEngine

# Included in DecisionEngine:
# var enemy : Enemy
# var current_state : EnemyState
# var blackboard : Blackboard

@onready var rh_attack: RHAttack = %RHAttack
@onready var rh_death: RHDeath = %RHDeath
@onready var rh_stun: RHStun = %RHStun
@onready var rh_walk: RHWalk = %RHWalk

@export var idle_state : EnemyState

func _ready() -> void:
	await super() # Maintains important setup code & timing
	pass


# All the conditions for making decisions go in this function
func decide() -> EnemyState:

	if blackboard.damage_source:
		if blackboard.health <= 0:
			return rh_death
		else:
			return rh_stun
		
	if current_state is RHDeath or not blackboard.can_decide:
		return null
		
	if blackboard.target:
		if rh_attack.can_attack():
			return rh_attack
		return rh_walk
		
	return rh_walk
