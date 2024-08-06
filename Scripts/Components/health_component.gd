extends Node
class_name HealthComponent

signal died
signal health_changed

var max_health: float
var current_health:float

func _ready():
	current_health = max_health

func config(set_max_health:float):
	max_health = set_max_health
	current_health = set_max_health

func damage(damage_amount:float):
	current_health = max(current_health - damage_amount, 0)
	health_changed.emit()
	Callable(check_death).call_deferred()

func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health,1)

func check_death():
	if current_health <= 0:
		died.emit(owner.global_position)
		owner.queue_free()
