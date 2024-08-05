extends PanelContainer
class_name LevelSelectCard



var level_resource: LevelResource

@onready var level_name_label = %LevelNameLabel
@onready var difficulty_label = %DifficultyLabel
@onready var time_label = %TimeLabel
@onready var drop_label = %DropLabel

@onready var preview = $MarginContainer/HBoxContainer/TextureRect

var disabled = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	

func start():
	level_name_label.text = level_resource.level_name
	difficulty_label.text = str(create_difficulty_text())
			
	time_label.text = "Time: " + str(level_resource.map_time / 60) + "min"
	drop_label.text = "Drop Chance: +" + str(int(level_resource.drop_chance * 100)) + "%"
	preview.texture = level_resource.preview

func create_difficulty_text():
	var text = "Difficulty: "
	
	for i in 5:
		if i < level_resource.difficulty:
			text += "★"
		else:
			text += "☆"
	return text


func play_in(delay:float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")
	
	
func play_discard():
	pass
	$AnimationPlayer.play("discard")
	await $AnimationPlayer.animation_finished
	
func select_card():
	disabled = true
	$AnimationPlayer.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("player_select_card"):
		if other_card == self:
			continue
		other_card.play_discard()
	
	await $AnimationPlayer.animation_finished
	await play_discard()
	
	GlobalVariables.level_resource = level_resource
	
	ScreenTransition.transition_to_scene("res://Scenes/Level/main.tscn")
	

func on_gui_input(event: InputEvent):
	if disabled:
		return
	
	if event.is_action_pressed("left_click"):
		select_card()
		

func on_mouse_entered():
	if disabled:
		return
	$HoverAnimationPlayer.play("hover")
