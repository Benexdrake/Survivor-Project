extends Node

const SPAWN_RADIUS = 500

@export var basic_enemy_scene: PackedScene
@export var skelet_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

@export var enemy_spawn_phases: Array[EnemySpawnPhase]

var enemy_table = WeightedTable.new()

var base_spawn_time = 0
var arena_difficulty:int = 1

func _ready():
	enemy_table.add_item(basic_enemy_scene,10)
	
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	
func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
		
	var spawn_position = Vector2.ZERO
		
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
			
	return spawn_position
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var enemies : Array[EnemyResource] = []
	
	for enemy_spawn_phase in enemy_spawn_phases:
		if enemy_spawn_phase.arena_difficulty == arena_difficulty:
			for enemy_resource in enemy_spawn_phase.enemy_resources:
				enemies.append(enemy_resource)
			timer.wait_time = enemy_spawn_phase.spawn_time
			timer.start()
			break
		
	var size = enemies.size() - 1
	
	if enemies.size() == 0:
		return
	
	var enemy_resource = enemies[randi_range(0, size)]
		
	var pos = get_spawn_position()
	var node = get_tree().get_first_node_in_group("entities_layer")
	
	enemy_resource.create_enemy(pos,node)

func on_arena_difficulty_increased(arena_difficult:int):
	self.arena_difficulty = arena_difficult
	var time_off = (.1 / 12) * arena_difficult
	time_off = min(time_off,.7)
	timer.wait_time = base_spawn_time - time_off
