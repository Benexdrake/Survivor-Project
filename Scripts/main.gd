extends Node
var player:Node2D
func _ready():
	player = get_node("Player") as CharacterBody2D
	
func _process(delta):
	if (int(player.global_position.x) / 100) % 5 == 0 and (int(player.global_position.x) > 100 or int(player.global_position.x) < -100):
		print("HELLO")
