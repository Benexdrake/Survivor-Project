extends Camera2D

var target_position = Vector2.ZERO

func _ready():
	make_current()

func _process(delta):
	aquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta*5))
	

func aquire_target():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	target_position = player.global_position
