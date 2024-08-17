extends Node
class_name GaymakerAbilityController

var scene = preload("res://Scenes/Abilitys/LovingUnicornAbilityController/loving_unicorn_ability.tscn")

func _ready():
	start()
	
func start():
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
	var background = get_tree().get_first_node_in_group("background_layer")
	
	var instance = scene.instantiate()
	background.add_child(instance)
	instance.global_position = player.global_position
