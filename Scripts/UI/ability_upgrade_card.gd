extends PanelContainer

signal selected

@onready var level_label:Label = %LevelLabel
@onready var texture_rect = %TextureRect

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel

var disabled = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	

func play_in(delay:float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")
	
	
func play_discard():
	$AnimationPlayer.play("discard")
	
	
func select_card():
	disabled = true
	$AnimationPlayer.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self:
			continue
		other_card.play_discard()
	
	await $AnimationPlayer.animation_finished
	selected.emit()
	

func set_ability_upgrade(upgrade: AbilityUpgrade):
	if upgrade != null:
		var level:int = 1
		for test in BgUpgrades.current_upgrades:
			var group_id = BgUpgrades.current_upgrades[test]["resource"].group_id
			if group_id == upgrade.group_id:
				level += BgUpgrades.current_upgrades[test]["quantity"]
			
		texture_rect.texture = upgrade.sprite
		level_label.text = "Level " + str(level)
		name_label.text = upgrade.name
		description_label.text = upgrade.description
		

func on_gui_input(event: InputEvent):
	if disabled:
		return
	
	if event.is_action_pressed("left_click"):
		select_card()
		

func on_mouse_entered():
	if disabled:
		return
	$HoverAnimationPlayer.play("hover")
