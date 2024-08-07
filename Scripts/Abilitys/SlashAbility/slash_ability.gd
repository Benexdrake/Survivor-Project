extends Node2D

@onready var hitbox_component : HitboxComponent = $HitboxComponent

func _ready():
	hitbox_component.area_entered.connect(on_area_entered)
	$AudioStreamPlayer.play()

func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
		
	global_position = player.global_position

	
func on_area_entered(other):
	$Hit.play()
