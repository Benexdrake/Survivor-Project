extends CanvasLayer

signal upgrade_selected(upgrade:AbilityUpgrade)

@export var upgrade_card_scene: PackedScene
@onready var card_container:HBoxContainer = %CardContainer
@onready var timer = $Timer
var canShuffle = true
var ui:CanvasLayer

func _ready():
	ui = get_tree().get_first_node_in_group("ui") as CanvasLayer
	ui.set_visibility(false)
	get_tree().paused = true
	timer.timeout.connect(on_timer_timeout)
	

func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	show_cards(upgrades)
	
	
func show_cards(upgrades: Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(delay)
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += .2
	var stories = GlobalVariables.player_resource.stories
	%StoryLabel.text = stories[randi_range(0,stories.size()-1)]


func on_upgrade_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	ui.set_visibility(true)
	queue_free()


func empty_cards():
	var delay = .2
	for card in card_container.get_children():
		card.play_discard()
		await get_tree().create_timer(delay).timeout
		card_container.remove_child(card)
		#delay += .2


func _input(event):
	if event.is_action_pressed("pause"):
		if !canShuffle:
			return
		timer.start()
		canShuffle = false
		await empty_cards()
		var upgrade_manager = get_tree().get_first_node_in_group("upgrade_manager") as UpgradeManager
		var upgrades = upgrade_manager.pick_upgrades()
		show_cards(upgrades)
		
		
func on_timer_timeout():
	canShuffle = true
