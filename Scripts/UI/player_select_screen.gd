extends CanvasLayer
class_name PlayerSelectScreen

var player_card = preload("res://Scenes/UI/player_select_card.tscn")


@export var player_cards: Resource
@onready var player_scroll_container = %PlayerScrollContainer

@onready var grid_container1 = %GridContainer1
@onready var grid_container2 = %GridContainer2
@onready var scroll_container = %ScrollContainer
@onready var timer = $Timer
@onready var description_label = %DescriptionLabel
@onready var animation_player = $PlayerInfobox/AnimationPlayer
@onready var panel_container = $PanelContainer


func _ready():
	show_cards()
	
func show_cards():
	var delay = 0
	var cards = player_cards.player_resources
	for i in cards.size():
		var pc = player_card.instantiate() as PlayerCard
		pc.player_resource = cards[i]
		if i % 2 == 0:
			grid_container1.add_child(pc)
		else:
			grid_container2.add_child(pc)
		pc.start()
		pc.play_in(delay)
		delay += .05
		
	timer.timeout.connect(on_timer_timeout)
	description_label.text
	player_scroll_container.scroll_vertical = 0


func change_description_laben(text:String):
	description_label.text = text
	scroll_container.scroll_vertical = 0


func on_timer_timeout():
	scroll_container.scroll_vertical +=1
