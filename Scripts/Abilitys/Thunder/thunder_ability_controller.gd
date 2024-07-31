extends Node

@export var max_range: float

@export var ability_scene : PackedScene
@export var damage:float = 10

var base_wait_time

func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Player
	
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() <= 0:
		return
		
	var sorted_enemies = enemies.filter(func(enemy:Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range,2)
	)
	
	var sword_instance = ability_scene.instantiate() as Node2D
	
	if sorted_enemies.size() == 0:
		return
	
	var rand_index:int = randi() % sorted_enemies.size()
	var random_enemy = 	sorted_enemies[rand_index]
	
	get_tree().get_first_node_in_group("foreground_layer").add_child(sword_instance)
	
	sword_instance.hitbox_component.damage = damage + player.base_damage
	
	sword_instance.global_position = random_enemy.global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU)) * 4
	
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	pass
