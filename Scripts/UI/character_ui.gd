extends CanvasLayer

@onready var progress_bar = $MarginContainer/ProgressBar

func change_health_bar(health):
	progress_bar.value = health
