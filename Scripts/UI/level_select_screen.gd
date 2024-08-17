extends CanvasLayer

var level_resources:AllLevelsResource = preload("res://Resources/Level/all_levels.tres")
@onready var grid_container = %GridContainer


var level_select_card = preload("res://Scenes/UI/level_select_card.tscn")

func _ready():
	%BackButton.pressed.connect(on_back_button_pressed)
	var delay = .2
	for level_resource in level_resources.all_levels:
		var card_instance = level_select_card.instantiate() as LevelSelectCard
		grid_container.add_child(card_instance)
		card_instance.level_resource = level_resource
		card_instance.start()
		card_instance.play_in(delay)
		delay += .2


func on_back_button_pressed():
	await ScreenTransition.transition_to_scene("res://Scenes/UI/player_select_screen.tscn")
