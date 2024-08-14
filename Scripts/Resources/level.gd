extends Resource
class_name LevelResource

@export var level_name:String
@export var spawn_phasen: Array[EnemySpawnPhase]
@export var preview:Texture
@export var map_time:int
@export var music:Array[AudioStream]
@export var map:PackedScene

# Global Variable
@export var drop_chance:float
@export var difficulty:int


func create_map():
	var map_instance = map.instantiate()
	GlobalVariables.level_resource.drop_chance = drop_chance
	return map_instance
