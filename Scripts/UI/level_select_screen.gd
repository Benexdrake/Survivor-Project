extends CanvasLayer

@export var level_resources: Array[LevelResource]
@onready var grid_container = $MarginContainer/GridContainer

var level_select_card = preload("res://Scenes/UI/level_select_card.tscn")

func _ready():
	var delay = .2
	for level_resource in level_resources:
		var card_instance = level_select_card.instantiate() as LevelSelectCard
		grid_container.add_child(card_instance)
		card_instance.level_resource = level_resource
		card_instance.start()
		card_instance.play_in(delay)
		delay += .2
