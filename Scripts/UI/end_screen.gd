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
	%BackButton.pressed.connect(on_back_button_pressed)

	
func set_victory():
	title_label.text = "Gewonnen"
	description_label.text = "Du hast per Schwarzarbeit " + str(GlobalVariables.money) + "DM erarbeitet!"
	$VictoryStreamPlayer.play()
	
func set_defeat():
	title_label.text = "Verloren"
	description_label.text = "Du hast verloren, du hast " + str(GlobalVariables.money) + " DM erarbeitet"
	$DefeatStreamPlayer.play()

func on_back_button_pressed():
	get_tree().paused = false
	await ScreenTransition.transition_to_scene("res://Scenes/UI/main_menu.tscn")
	
	
