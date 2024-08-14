extends Node

@export var axe_ability_scene:PackedScene
@onready var cooldown_timer = $CooldownTimer
@onready var spawn_timer = $SpawnTimer

var max_axes:int = 2
var current_axes:int = 0

@export var damage = 10

func _ready():
	cooldown_timer.timeout.connect(on_timer_timeout)
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	
func ability():
	create_axe()
	for i in max_axes:
		pass
		
		
func create_axe():
	var player = get_tree().get_first_node_in_group("player") as Player
	
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	if foreground == null:
		return
	var axe_ability_instance = axe_ability_scene.instantiate() as AxeAbility
	foreground.add_child(axe_ability_instance)
	axe_ability_instance.global_position = player.global_position
	
	
	axe_ability_instance.start(player.global_position, damage + player.base_dmg)

func on_timer_timeout():
	spawn_timer.start()
	
func on_spawn_timer_timeout():
	ability()
	current_axes +=1
	
	if current_axes == max_axes:
		spawn_timer.stop()
		current_axes = 0

func on_ability_upgrade_added(upgrade:AbilityUpgrade):
	pass
