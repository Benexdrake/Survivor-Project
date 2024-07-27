extends Node

@export var ability_scene: PackedScene

@export var damage:float = 3


func _ready():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("background_layer")
		
	var ability_instance = ability_scene.instantiate() as Node2D
	foreground.add_child(ability_instance)
	ability_instance.hitbox_component.damage = damage
