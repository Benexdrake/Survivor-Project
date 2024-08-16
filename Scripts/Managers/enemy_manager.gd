extends Node

const SPAWN_RADIUS = 500

@export var arena_time_manager: Node

@onready var timer = $Timer

var enemy_spawn_phases: Array[EnemySpawnPhase]

var enemy_table = WeightedTable.new()

var base_spawn_time = 0
var spawn_difficulty:int = 1
var arena_difficulty:int = 1

var current_enemies : Array[EnemyResource] = []

func _ready():
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
		
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
		
	if entities_layer == null:
		return
		
	var size = current_enemies.size() - 1
	var enemy_resource = current_enemies[randi_range(0, size)]
		
	create_enemy(entities_layer,enemy_resource)
	create_horde_enemies(entities_layer,enemy_resource)
	
	timer.start()
	
func create_enemy(entities_layer,enemy_resource):
	for i in spawn_difficulty:
		var pos = get_spawn_position()
		enemy_resource.create_enemy(pos,entities_layer)
		
func create_horde_enemies(entities_layer,enemy_resource):
	if randf() < .1:
		var pos = get_spawn_position()
		for i in 10:
			var p = pos + Vector2.RIGHT.rotated(randf_range(0, TAU))
			enemy_resource.create_enemy(p,entities_layer, true)
		

func on_arena_difficulty_increased(arena_difficult:int):
	enemy_table = WeightedTable.new()
	for spawn_phase in GlobalVariables.level_resource.spawn_phasen:
		enemy_table.add_item(spawn_phase,spawn_phase.weight)
	
	current_enemies = []
	
	var enemy_phase = enemy_table.pick_item()
	#var enemy_phase = enemy_spawn_phases[0]
	
	
	self.arena_difficulty = arena_difficult
	
	spawn_difficulty = enemy_phase.difficulty
	for enemy_resource in enemy_phase.enemy_resources:
		current_enemies.append(enemy_resource)
	
	
	if owner.level_resource.difficulty == 6:
		timer.wait_time = .1
		
	else:
		timer.wait_time = enemy_phase.spawn_time - (float(owner.level_resource.difficulty) / 10)
	timer.start()
	
	var arena_wave_ui = get_tree().get_first_node_in_group("arena_wave_ui")
	arena_wave_ui.arena_wave_label(arena_difficult)
