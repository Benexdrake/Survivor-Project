extends Node2D

@onready var timer = $Timer
@onready var hitbox_component = $HitboxComponent
@onready var collision_shape_2d = %CollisionShape2D
@onready var sprite_2d = $Sprite2D

var convince_chance:float = .02

func _ready():
	timer.timeout.connect(on_timer_timeout)
	
	
func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	global_position = player.global_position
	

func on_timer_timeout():
	
	collision_shape_2d.disabled = !collision_shape_2d.disabled
