extends Node

var friend_scene = preload("res://Scenes/Enemys/friendly_enemy.tscn")

func _ready():
	pass
	
	
func check_speech(abilityname):
	if abilityname == "PersuasiveSpeech":
		var rand = randf_range(0,1)
		if rand >= .98:
			var friend_instantiate = friend_scene.instantiate() as Node2D
			var layer = get_tree().get_first_node_in_group("entities_layer")
			
			await layer.call_deferred("add_child", friend_instantiate)
			friend_instantiate.set_deferred("global_position",owner.global_position)
			#friend_instantiate.global_position = owner.global_position
			owner.queue_free()
		return true
	else:
		return false
