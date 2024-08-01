extends Node

@export var knockback_power: int = 50
@onready var timer = $Timer

func knockback():
	timer.start()
	
	var owner = get_parent() as Node2D
	
	var velocity = owner.velocity
	var knockback_direction = -velocity * knockback_power
	owner.velocity = knockback_direction
	owner.move_and_slide()
