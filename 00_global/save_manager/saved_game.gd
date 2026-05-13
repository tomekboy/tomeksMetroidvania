class_name SavedGame extends Resource

# scene / level path
@export var scene_path : String

# player data
@export var player_position : Vector2
@export var player_hp : float
@export var player_max_hp : float
@export var player_cp : float
@export var player_max_cp : float
@export var player_dash : bool
@export var player_double_jump : bool
@export var player_ground_slam : bool
@export var player_morph_roll : bool

# game data
@export var game_discovered_areas : Array = []
@export var game_persistent_data : Dictionary = {}

# dynamic object data
@export var saved_data : Array[SavedData] = []
