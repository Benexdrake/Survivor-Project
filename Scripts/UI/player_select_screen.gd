extends CanvasLayer

@export var player_cards: Resource
@export var player_card:PackedScene

@onready var grid_container = %GridContainer

func _ready():
	for card in player_cards.player_resources:
		var pc = player_card.instantiate() as PlayerCard
		pc.player_resource = card
		grid_container.add_child(pc)
		pc.start()
