class_name DecisionEngineRhinoFight extends RhinoDecisionEngine

# Included in DecisionEngine:
# var boss : Rhino
# var current_state : RhinoState
# var blackboard : Blackboard

@onready var rh_attack: RHAttack = %RHAttack
@onready var rh_chase: RHChase = %RHChase
@onready var rh_death: RHDeath = %RHDeath
@onready var rh_stun: RHStun = %RHStun
@onready var rh_walk: RHWalk = %RHWalk

func _ready() -> void:
	await super() # Maintains important setup code & timing
	pass


# All the conditions for making decisions go in this function
func decide() -> RhinoState:

	if blackboard.damage_source:
		if blackboard.health <= 0:
			return rh_death
		else:
			return rh_stun
		
	if current_state is RHDeath or not blackboard.can_decide:
		return null
		
	if blackboard.edge_detected:
		boss.change_dir( -blackboard.dir )
	
	if blackboard.target:
		if  rh_attack.can_attack():
			return rh_attack
		return rh_chase
		
	return rh_walk # default state
