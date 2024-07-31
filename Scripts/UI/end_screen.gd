extends CanvasLayer

@onready var title_label = %TitleLabel
@onready var description_label = %DescriptionLabel

@onready var panel_container = %PanelContainer


func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)
	
func set_victory():
	title_label.text = "Gewonnen"
	description_label.text = "Du hast per Schwarzarbeit X DM erarbeitet!"
	$VictoryStreamPlayer.play()
	
func set_defeat():
	title_label.text = "Verloren"
	description_label.text = "Du hast verloren, du hast X DM erarbeitet, jedoch nimmt der Staat dir 45% von weg, dir bleiben X DM!"
	$DefeatStreamPlayer.play()

func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Level/main.tscn")
	
	
func on_quit_button_pressed():
	get_tree().quit()
