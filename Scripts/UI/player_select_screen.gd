extends CanvasLayer
class_name PlayerSelectScreen

@export var player_cards: Resource
@export var player_card:PackedScene
@onready var player_scroll_container = %PlayerScrollContainer

@onready var grid_container = %GridContainer
@onready var scroll_container = %ScrollContainer
@onready var timer = $Timer
@onready var description_label = %DescriptionLabel

func _ready():
	var delay = .2
	for card in player_cards.player_resources:
		var pc = player_card.instantiate() as PlayerCard
		pc.player_resource = card
		grid_container.add_child(pc)
		pc.start()
		pc.play_in(delay)
		delay += .2
		
	timer.timeout.connect(on_timer_timeout)
	description_label.text
	player_scroll_container.scroll_vertical = 0
	

func change_description_laben(text:String):
	description_label.text = text
	scroll_container.scroll_vertical = 0


func on_timer_timeout():
	scroll_container.scroll_vertical +=1
