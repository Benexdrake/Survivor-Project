extends CanvasLayer

@onready var title_label = %TitleLabel
@onready var description_label = %DescriptionLabel

func _ready():
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)
	
func set_victory():
	title_label.text = "Gewonnen"
	description_label.text = "Du hast per Schwarzarbeit X DM erarbeitet!"
	
func set_defeat():
	title_label.text = "Verloren"
	description_label.text = "Du hast verloren, du hast X DM erarbeitet, jedoch nimmt der Staat dir 45% von weg, dir bleiben X DM!"

func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Level/main.tscn")
	
	
func on_quit_button_pressed():
	get_tree().quit()
