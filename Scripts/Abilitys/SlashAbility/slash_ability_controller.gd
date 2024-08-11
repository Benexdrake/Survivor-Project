extends Node

@export var slash_ability_scene: PackedScene

@export var damage = 10

@onready var timer = $Timer
@onready var second_slash_timer = $SecondSlashTimer

var hasDoubleSlashUpgrade = false
var hasFirstSlash = false

func _ready():
	timer.timeout.connect(on_timer_timeout)
	second_slash_timer.timeout.connect(on_second_slash_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func create():
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
		
	var ability_instance = slash_ability_scene.instantiate() as Node2D
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
		
	foreground.add_child(ability_instance)
	ability_instance.global_position = player.global_position
	ability_instance.hitbox_component.damage = damage + player.base_dmg
	
	var scale = player.visuals.scale
	ability_instance.scale = scale
	if hasFirstSlash:
		ability_instance.scale.x = -scale.x

func on_timer_timeout():
	create()
	if hasDoubleSlashUpgrade:
		hasFirstSlash = true
		second_slash_timer.start()
		
		
func on_second_slash_timer_timeout():
	create()
	hasFirstSlash = false
	

func on_ability_upgrade_added(upgrade: AbilityUpgrade):
	if upgrade.id == "slash_speed_upgrade":
		timer.wait_time = timer.wait_time * .9
	if upgrade.id == "slash_double_upgrade":
		hasDoubleSlashUpgrade = true
