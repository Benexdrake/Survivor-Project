extends PanelContainer
class_name PlayerCard

@export var player_resource:PlayerResource

@onready var character_name_label:Label = %CharacterNameLabel
@onready var preview = %Preview
@onready var stats_label:Label = %StatsLabel

var disabled = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)

func start():
	character_name_label.text = player_resource.player_name
	preview.texture = player_resource.preview
	stats_label.text = get_stats()
	

func get_stats():
	var stats = ""
	stats += "ATK: " + get_points(int(player_resource.dmg_show)) + "\n"
	stats += "HP: " + get_points(int(player_resource.hp_show)) + "\n"
	stats += "SPD: " + get_points(int(player_resource.speed_show))
	return stats


func get_points(variable:int):
	var points = ""
	for i in variable:
		points += "[]"
	return points

	

func play_in(delay:float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")
	
	
func play_discard():
	$AnimationPlayer.play("discard")
	
	
func select_card():
	disabled = true
	$AnimationPlayer.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("player_select_card"):
		if other_card == self:
			continue
		other_card.play_discard()
	
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("discard")
	await $AnimationPlayer.animation_finished
	
	GameEvents.player_resource = player_resource
	get_tree().change_scene_to_file("res://Scenes/Level/main.tscn")
	

func on_gui_input(event: InputEvent):
	if disabled:
		return
	
	if event.is_action_pressed("left_click"):
		select_card()
		

func on_mouse_entered():
	if disabled:
		return
	$HoverAnimationPlayer.play("hover")
