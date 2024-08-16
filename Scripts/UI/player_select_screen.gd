extends CanvasLayer
class_name PlayerSelectScreen

var player_card = preload("res://Scenes/UI/player_select_card.tscn")


@export var player_cards: Resource
@onready var player_scroll_container = %PlayerScrollContainer

@onready var grid_container = %GridContainer
@onready var scroll_container = %ScrollContainer
@onready var timer = $Timer
@onready var description_label = %DescriptionLabel
@onready var information_margin_container = %InformationMarginContainer
@onready var animation_player = $PlayerInfobox/AnimationPlayer


func _ready():
	show_cards()
	
func show_cards():
	var delay = 0
	for card in player_cards.player_resources:
		var pc = player_card.instantiate() as PlayerCard
		pc.player_resource = card
		grid_container.add_child(pc)
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
