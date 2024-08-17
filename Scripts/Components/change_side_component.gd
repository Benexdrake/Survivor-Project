extends Node

var friend_scene = preload("res://Scenes/Enemys/friendly_enemy.tscn")
var friend2_scene = preload("res://Scenes/Enemys/friendly_enemy2.tscn")

func _ready():
	pass
	
	
func check_speech(ability):
	if ability.name == "LovingUnicornAbility":
		var rand = randf_range(0,1)
		if rand <= ability.convince_chance:
			var friend2_instantiate = friend2_scene.instantiate() as Node2D
			var layer = get_tree().get_first_node_in_group("entities_layer")
			
			await layer.call_deferred("add_child", friend2_instantiate)
			friend2_instantiate.set_deferred("global_position",owner.global_position)
			friend2_instantiate.call_deferred("start",owner.animated_sprite_2d.sprite_frames)
			return true
	
	if ability.name == "PersuasiveSpeech":
		var rand = randf_range(0,1)
		
		if rand <= ability.convince_chance:
			var friend_instantiate = friend_scene.instantiate() as Node2D
			var layer = get_tree().get_first_node_in_group("entities_layer")
			
			await layer.call_deferred("add_child", friend_instantiate)
			friend_instantiate.set_deferred("global_position",owner.global_position)
			return true
		return false
