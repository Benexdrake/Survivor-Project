extends Node

@export var ability_scene: PackedScene

@export var damage:float = 3

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(on_timer_timeout)
	


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("background_layer")
		
	var ability_instance = ability_scene.instantiate() as Node2D
	foreground.add_child(ability_instance)
	ability_instance.hitbox_component.damage = damage + player.base_damage
	ability_instance.global_position = player.global_position
