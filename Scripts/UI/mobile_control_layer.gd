extends CanvasLayer

@onready var touch_screen_button = $TouchScreenButton

func show_button():
	$AnimationPlayer.play("default")
	
func hide_button():
	$AnimationPlayer.play_backwards("default")
