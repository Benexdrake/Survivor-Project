extends Node

@export var knockback_power: float = 50
@onready var timer = $Timer

func knockback(velocity):
	timer.start()
	
	var knockback_direction = -velocity
	owner.velocity = knockback_direction
	owner.move_and_slide()
