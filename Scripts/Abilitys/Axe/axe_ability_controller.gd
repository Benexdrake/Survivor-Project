extends Node

@export var axe_ability_scene:PackedScene
@onready var cooldown_timer = $CooldownTimer

var max_axes = 1

@export var damage = 10

func _ready():
	cooldown_timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	#ability()
	
	
func ability():
	for i in max_axes:
		create_axe()
	
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
	ability()

func on_ability_upgrade_added(upgrade:AbilityUpgrade):
	pass
