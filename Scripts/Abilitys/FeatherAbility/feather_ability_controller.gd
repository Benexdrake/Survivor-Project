extends Node

var ability_scene = preload("res://Scenes/Abilitys/ShurikenAbility/shuriken_ability.tscn")

@export var damage = 5

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Player
	
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	
	if foreground == null:
		return
	
	var ability_instance = ability_scene.instantiate() as Node2D
	foreground.add_child(ability_instance)
	ability_instance.global_position = player.global_position
	ability_instance.hitbox_component.damage = damage + player.base_dmg
	
