extends CanvasLayer

signal kill_counter

@onready var kill_counter_label = %KillCounterLabel

var kill_counter_number:int = 0

func _ready():
	kill_counter.connect(on_killed)
	
	
func on_killed():
	kill_counter_number+=1
	kill_counter_label.text = str(kill_counter_number)
