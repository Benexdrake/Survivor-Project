extends Node

@onready var timer = $Timer

var isKnockback:bool

func _ready():
	timer.timeout.connect(on_timer_timeout)


func knockback(knockback_power):
	isKnockback = true
	timer.start()	
	var knockback_direction = -owner.velocity
	owner.velocity = knockback_direction * knockback_power
	owner.move_and_slide()


func on_timer_timeout():
	isKnockback = false
