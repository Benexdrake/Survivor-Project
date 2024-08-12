extends Node
class_name BookAbilityController

# speed 5
# Spawn Timer 2: 0.6 3: 0.4 4: 0.3 5: 0.5
@export var max_spawn = 2
var spawns = 0

var upgrade_level = 1

@export var ability_scene: PackedScene
@export var book_sprite:Texture
@export var damage = 5

@onready var timer = $Timer
@onready var spawn_timer = $SpawnTimer

func _ready():
	timer.timeout.connect(on_timer_timeout)
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	
func on_timer_timeout():
	delete_books()
	timer.wait_time = 20
	timer.start()
	spawn_timer.start()
	spawn()
	
	
func on_spawn_timer_timeout():
	spawn()
	

func delete_books():
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	if foreground == null:
		return
	var ability_instance = ability_scene.instantiate() as Node2D
	foreground.add_child(ability_instance)
	ability_instance.stop()
	

func spawn():
	var player = get_tree().get_first_node_in_group("player") as Player
	
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	
	if foreground == null:
		return
	var ability_instance = ability_scene.instantiate() as Node2D
	foreground.add_child(ability_instance)
	
	ability_instance.sprite_2d.texture = book_sprite
	ability_instance.global_position = player.global_position
	ability_instance.hitbox_component.damage = damage + player.base_dmg
	
	spawns += 1
	
	if spawns == max_spawn:
		spawns = 0
		spawn_timer.stop()
	
func on_ability_upgrade_added(upgrade:AbilityUpgrade):
	if upgrade.id == "book_upgrade":
		upgrade_level += 1
		if upgrade_level == 2:
			damage *= 1.25
			spawn_timer.wait_time = 0.4
			max_spawn = 3
			restart()
		elif upgrade_level == 3:
			damage *= 1.25
			spawn_timer.wait_time = 0.3
			max_spawn = 4
			restart()
		elif upgrade_level == 4:
			damage *= 1.25
			spawn_timer.wait_time = 0.5
			max_spawn = 5
			restart()
		
func restart():
	var abilitys = get_tree().get_nodes_in_group("book_ability")
	for a in abilitys:
		a.queue_free()
	spawn_timer.start()
	timer.stop()
	timer.start()
	spawn()
