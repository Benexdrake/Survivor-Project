extends Node
@onready var timer = $Timer

@export var max_range: float

@export var ability_scene : PackedScene
@export var thunder_ball_scene : PackedScene
@export var damage:float

var thunder_ball:bool

func _ready():
	timer.timeout.connect(on_timer_timeout)
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
	
	var thunder_instance = ability_scene.instantiate() as Node2D
	
	if sorted_enemies.size() == 0:
		return
	
	var rand_index:int = randi() % sorted_enemies.size()
	var random_enemy = 	sorted_enemies[rand_index]
	
	get_tree().get_first_node_in_group("foreground_layer").add_child(thunder_instance)
	
	thunder_instance.hitbox_component.damage = damage + player.base_dmg
	
	thunder_instance.global_position = random_enemy.global_position
	thunder_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU)) * 4
	
	# Einschlag
	if thunder_ball:
		var thunder_ball_instance = thunder_ball_scene.instantiate()
		get_tree().get_first_node_in_group("foreground_layer").add_child(thunder_ball_instance)
		thunder_ball_instance.hitbox_component.damage = (damage + player.base_dmg) * .1
		thunder_ball_instance.global_position = thunder_instance.global_position
		
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade):
	if upgrade.id == "thunder_upgrade":
		thunder_ball = true
		damage *= .25
		timer.wait_time *= .9
		timer.start()
		
