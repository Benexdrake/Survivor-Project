extends CharacterBody2D

@export var max_speed:int

@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals = $Visuals


func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * max_speed
	move_and_slide()
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign,1)
	
	
func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	return (player.global_position - global_position).normalized()
