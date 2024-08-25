extends CanvasLayer

@onready var psc_1: TestPlayerCard = $HBoxContainer/PlayerSelectCard1
@onready var psc_2: TestPlayerCard = $HBoxContainer/PlayerSelectCard2
@onready var psc_3: TestPlayerCard = $HBoxContainer/PlayerSelectCard3
@onready var psc_4: TestPlayerCard = $HBoxContainer/PlayerSelectCard4
@onready var psc_5: TestPlayerCard = $HBoxContainer/PlayerSelectCard5




const CARD_SCENE = preload("res://Test_Scene/test_player_select_card.tscn")
const ALL_PLAYERS = preload("res://Resources/Players/all_players.tres")

var all = ALL_PLAYERS.player_resources

var mid_index = 0

func _ready() -> void:
	psc_1.create(all[all.size()-2])
	psc_2.create(all[all.size()-1])
	psc_3.create(all[0])
	psc_4.create(all[1])
	psc_5.create(all[2])

func _input(event: InputEvent) -> void:
	if Input.get_connected_joypads().size() > 0:
		print("Erkennt Controller, somit ist es möglich die Buttons anzupassen")
		
	if event.is_action_pressed("move_left"):
		mid_index += 1
		change_cards_left()
	
	if event.is_action_pressed("move_right"):
		mid_index -= 1
		change_cards_right()


func change_cards_left():
	var size = all.size() -1
	
	if mid_index > size:
		mid_index = 0
	
	if mid_index == 0:
		psc_1.create(all[size-1])
		psc_2.create(all[size])
		psc_3.create(all[0])
		psc_4.create(all[1])
		psc_5.create(all[2])
	elif mid_index + 2 < size:
		if mid_index - 1 == 0:
			psc_1.create(all[size])
		else:
			psc_1.create(all[mid_index - 2])
		psc_2.create(all[mid_index - 1])
		psc_3.create(all[mid_index])
		psc_4.create(all[mid_index + 1])
		psc_5.create(all[mid_index + 2])
	elif mid_index + 2 == size:
		psc_1.create(all[mid_index - 2])
		psc_2.create(all[mid_index - 1])
		psc_3.create(all[mid_index])
		psc_4.create(all[mid_index + 1])
		psc_5.create(all[mid_index + 2])
	elif mid_index + 1 == size:
		psc_1.create(all[mid_index - 2])
		psc_2.create(all[mid_index - 1])
		psc_3.create(all[mid_index])
		psc_4.create(all[mid_index + 1])
		psc_5.create(all[0])
	elif mid_index == size:
		psc_1.create(all[mid_index - 2])
		psc_2.create(all[mid_index - 1])
		psc_3.create(all[mid_index])
		psc_4.create(all[0])
		psc_5.create(all[1])
		mid_index = -1
	
func change_cards_right():
	var size = all.size() -1
	
	if mid_index < 0:
		mid_index = size
	
	if mid_index == 0:
		psc_1.create(all[size-1])
		psc_2.create(all[size])
		psc_3.create(all[0])
		psc_4.create(all[1])
		psc_5.create(all[2])
	elif mid_index == size:
		psc_1.create(all[mid_index - 2])
		psc_2.create(all[mid_index - 1])
		psc_3.create(all[mid_index])
		psc_4.create(all[0])
		psc_5.create(all[1])
	elif mid_index + 1 == size:
		psc_1.create(all[mid_index - 2])
		psc_2.create(all[mid_index - 1])
		psc_3.create(all[mid_index])
		psc_4.create(all[mid_index + 1])
		psc_5.create(all[0])
	elif mid_index - 1 == 0:
		psc_1.create(all[size])
		psc_2.create(all[0])
		psc_3.create(all[mid_index])
		psc_4.create(all[mid_index + 1])
		psc_5.create(all[mid_index + 2])
	else:
		psc_1.create(all[mid_index - 2])
		psc_2.create(all[mid_index - 1])
		psc_3.create(all[mid_index])
		psc_4.create(all[mid_index + 1])
		psc_5.create(all[mid_index + 2])
	
