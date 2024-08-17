extends PanelContainer
class_name PlayerCard

var player_resource:PlayerResource

@onready var character_name_label:Label = %CharacterNameLabel
@onready var preview = %Preview
@onready var attack_label = %AttackLabel
@onready var health_label = %HealthLabel
@onready var speed_label = %SpeedLabel


var disabled = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)


func start():
	character_name_label.text = player_resource.player_name
	preview.texture = player_resource.preview
	%AbilityIcon.texture = player_resource.ability.icon
	if !player_resource.is_available:
		disabled = true
		$TextureRect.visible = true
	stats()
	
	
func stats():
	attack_label.text = str(player_resource.dmg_show)
	health_label.text = str(player_resource.hp_show)
	speed_label.text = str(player_resource.speed_show)

	

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
	
	GlobalVariables.player_resource = player_resource
	ScreenTransition.transition_to_scene("res://Scenes/UI/level_select_screen.tscn")
	

func on_gui_input(event: InputEvent):
	if disabled:
		return
	
	if event.is_action_pressed("left_click"):
		select_card()
		

func on_mouse_entered():
	z_index = 1
	if disabled:
		return
	
	var player_select_screen = get_tree().get_first_node_in_group("player_select_screen") as PlayerSelectScreen
	player_select_screen.change_description_laben(player_resource.description)
	player_select_screen.panel_container.visible = true
	player_select_screen.animation_player.play("show")
	$HoverAnimationPlayer.play("hover")
	
	
func on_mouse_exited():
	z_index = 0
	var player_select_screen = get_tree().get_first_node_in_group("player_select_screen") as PlayerSelectScreen
	player_select_screen.panel_container.visible = false
	player_select_screen.animation_player.play_backwards("show")
	
