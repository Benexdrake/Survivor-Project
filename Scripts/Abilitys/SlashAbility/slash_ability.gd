extends Node2D

@onready var hitbox_component : HitboxComponent = $HitboxComponent

func _ready():
	$AudioStreamPlayer.play()

func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
		
	global_position = player.global_position
