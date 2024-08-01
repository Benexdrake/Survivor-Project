extends Node

@export var slash_ability_scene: PackedScene

@export var damage = 10

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
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
	
