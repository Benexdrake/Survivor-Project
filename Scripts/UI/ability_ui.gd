extends CanvasLayer
class_name AbilityUI

@onready var grid_container = $GridContainer
var ability_card = preload("res://Scenes/UI/ability_panel_container_card.tscn")

var ability_cards:Array[AbilityPanelCard]

@export var max_cards:int = 10

func _ready():
	for i in max_cards:
		var card_instance = ability_card.instantiate()
		ability_cards.append(card_instance)
		grid_container.add_child(card_instance)

func check_ability_cards(icon):
	for card in ability_cards:
		if !card.has_icon:
			card.add_icon(icon)
			break;
