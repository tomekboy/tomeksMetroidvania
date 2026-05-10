class_name DecisionEngineBasicAttack extends DecisionEngine

# Included in DecisionEngine:
# var enemy : Enemy
# var current_state : EnemyState
# var blackboard : Blackboard

@onready var es_attack: ESAttack = $"../EnemyStateMachine/ESAttack"
@onready var es_chase: ESChase = $"../EnemyStateMachine/ESChase"
@onready var es_death: ESDeath = $"../EnemyStateMachine/ESDeath"
@onready var es_stun: ESStun = $"../EnemyStateMachine/ESStun"
@onready var es_walk: ESWalk = $"../EnemyStateMachine/ESWalk"

func _ready() -> void:
	await super() # Maintains important setup code & timing
	pass


# All the conditions for making decisions go in this function
func decide() -> EnemyState:

	if blackboard.damage_source:
		if blackboard.health <= 0:
			return es_death
		else:
			return es_stun
		
	if current_state is ESDeath or not blackboard.can_decide:
		return null
		
	if blackboard.edge_detected:
		enemy.change_dir( -blackboard.dir )
	
	if blackboard.target:
		if  es_attack.can_attack():
			return es_attack
		return es_chase
		
	return es_walk # default state
