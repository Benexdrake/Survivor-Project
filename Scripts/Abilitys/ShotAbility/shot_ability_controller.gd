extends Node2D

var shot_ability_scene = preload("res://Scenes/Abilitys/ShotAbility/shot_ability.tscn")

@onready var timer = $Timer
@onready var spawn_timer = $SpawnTimer

var max_shots = 3
var current_shots = 0

@export var damage = 5

func _ready():
	timer.timeout.connect(on_timer_timeout)
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	
func _input(event):
	if Input.is_action_just_pressed("move_up"):
		rotate(-90)
	elif Input.is_action_just_pressed("move_down"):
		rotate(90)
	
func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Player
	
	if player == null:
		return
		
	global_position = player.global_position

func shoot():
	var player = get_tree().get_first_node_in_group("player") as Player
	
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	
	if foreground == null:
		return
	
	var bullet = shot_ability_scene.instantiate()
	foreground.add_child(bullet)
	bullet.hitbox_component.damage = damage + player.base_dmg
	bullet.position = %Marker2D.global_position
	
func on_timer_timeout():
	spawn_timer.start()
	
	
func on_spawn_timer_timeout():
	shoot()
	current_shots +=1
	if current_shots == max_shots:
		spawn_timer.stop()
		current_shots = 0
	
