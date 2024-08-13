extends Node2D
class_name KamehamehaController

var shot_ability_scene = preload("res://Scenes/Abilitys/KamehamehaAbility/kamehameha_ability.tscn")

@onready var timer = $Timer
@onready var marker_2d = %Marker2D


var max_shots = 3
var current_shots = 0

@export var damage = 5
var velocity = Vector2(1,0)

func _ready():
	timer.timeout.connect(on_timer_timeout)
	
func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Player
	
	if player == null:
		return
		
	global_position = player.global_position
	check_input()
	

	
	
func check_input():
	if Input.is_action_pressed("move_up"):
		rotation_degrees = -90
		velocity = Vector2(0,-1)
	elif Input.is_action_pressed("move_down"):
		rotation_degrees = 90
		velocity = Vector2(0,1)
	elif Input.is_action_pressed("move_left"):
		rotation_degrees = 180
		velocity = Vector2(-1,0)
	elif Input.is_action_pressed("move_right"):
		rotation = 0
		velocity = Vector2(1,0)

func shoot():
	var player = get_tree().get_first_node_in_group("player") as Player
	
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	
	if foreground == null:
		return
	
	var bullet = shot_ability_scene.instantiate()
	foreground.add_child(bullet)
	bullet._velocity = velocity
	bullet.hitbox_component.damage = damage + player.base_dmg
	bullet.position = marker_2d.global_position
	bullet.rotation_degrees = rotation_degrees
	
func on_timer_timeout():
	shoot()
