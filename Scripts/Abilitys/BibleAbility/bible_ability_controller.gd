extends Node
class_name BibleAbilityController

# Spawn Timer 2: 0.6 3: 0.4 4: 0.3 5: 0.5
@export var max_spawn = 2
var spawns = 0

@export var ability_scene: PackedScene
@export var damage = 5

@onready var timer = $Timer
@onready var spawn_timer = $SpawnTimer

var d := 0.0
var radius = 100.0
var speed = 10.0

func _ready():
	timer.timeout.connect(on_timer_timeout)
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	
func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	
	d += delta
	
func on_timer_timeout():
	timer.wait_time = 20
	timer.start()
	spawn_timer.start()
	spawn()
	
func on_spawn_timer_timeout():
	spawn()
	

func spawn():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	
	if foreground == null:
		return
	var ability_instance = ability_scene.instantiate() as Node2D
	foreground.add_child(ability_instance)
	ability_instance.global_position = player.global_position
	ability_instance.hitbox_component.damage = damage
	
	spawns += 1
	
	if spawns == max_spawn:
		spawns = 0
		spawn_timer.stop()
	
