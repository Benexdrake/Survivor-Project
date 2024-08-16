extends Node2D
class_name GaymakerAbility

var heart = preload("res://Scenes/Abilitys/GaymakerAbilityController/herzchen.tscn")
@onready var timer = $Timer
@onready var heart_timer = $HeartTimer
@onready var collision_shape_2d = %CollisionShape2D

var spawn_radius:float = 400
var convince_chance:float = .01

func _ready():
	timer.timeout.connect(on_timer_timeout)
	heart_timer.timeout.connect(on_heart_timer_timeout)
	

func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Player
	
	global_position = player.global_position

	
func create_heart():
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	spawn_position = global_position + (random_direction * randf_range(10,spawn_radius))
	
	var heart_instance = heart.instantiate() as Node2D
	
	var layer = get_tree().get_first_node_in_group("background_layer")
		
	if layer == null:
		return
		
	layer.add_child(heart_instance)
	heart_instance.global_position = spawn_position
	
	
	
func on_timer_timeout():
	collision_shape_2d.disabled = !collision_shape_2d.disabled
	
func on_heart_timer_timeout():
	for i in 10:
		create_heart()
	
