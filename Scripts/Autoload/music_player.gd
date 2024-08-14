extends AudioStreamPlayer

@export var bgms: Array[AudioStream]

func _ready():
	finished.connect(on_finished)
	$Timer.timeout.connect(on_timer_timeout)
	
	
func on_finished():
	$Timer.start()


func on_timer_timeout():
	random_bgm()
	

func random_bgm():
	var index = randi_range(0, bgms.size()-1)
	
	stream = bgms[index]
	play()
