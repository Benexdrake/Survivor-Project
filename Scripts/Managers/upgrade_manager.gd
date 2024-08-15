extends Node
class_name UpgradeManager

@export var filler: AbilityUpgrade
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene
@export var all_upgrades:Resource
@export var max_abilitys:int = 10

var current_upgrades: Array[AbilityUpgrade]
var upgrade_pool: UpgradeWeightedTable = UpgradeWeightedTable.new()


func _ready():
	experience_manager.level_up.connect(on_level_up)
	
	
func adding_upgrades():
	var player = get_tree().get_first_node_in_group("player") as Player
	all_upgrades.attack_upgrades.shuffle()
	all_upgrades.passiv_upgrades.shuffle()
	
	
	var upgrades = []
	
	if player.player_resource.ability.upgrades.size() > 0:
		upgrades.append(player.player_resource.ability)
	
	if all_upgrades.attack_upgrades.size() < 10 - upgrades.size():
		max_abilitys = all_upgrades.all_upgrades.size()
	
	for i in max_abilitys:
		if all_upgrades.attack_upgrades[i].id == player.player_resource.ability.id:
			max_abilitys +=1
			continue
		upgrades.append(all_upgrades.attack_upgrades[i])
	
	for upgrade in all_upgrades.passiv_upgrades:
		upgrades.append(upgrade)
	
	upgrades.shuffle()
	
	for ability in upgrades:
		if ability is AbilityUpgradeCard:
			if ability.upgrades.size() == 0:
				ability.max_level = 1
			else:
				ability.max_level = ability.upgrades.size() + 1
		upgrade_pool.add_item(ability)

	
func apply_upgrade(upgrade: AbilityUpgrade):
	if upgrade.level == 0:
		GameEvents.emit_ability_upgrade_added(upgrade)
		if !upgrade.is_passiv_ability:
			var ability_ui = get_tree().get_first_node_in_group("ability_ui") as AbilityUI
			ability_ui.check_ability_cards(upgrade.icon)
	else:
		if upgrade is AbilityUpgradeCard:
			GameEvents.emit_ability_upgrade_added(upgrade.upgrades[upgrade.level - 1])
		else:
			GameEvents.emit_ability_upgrade_added(upgrade)
	upgrade.level += 1
	if current_upgrades.has(upgrade):
		return
	current_upgrades.append(upgrade)


func pick_upgrades():
	var chosen_upgrades:Array[AbilityUpgrade] = []
	var exclude:Array[AbilityUpgrade] = []
	for ability in current_upgrades:
		upgrade_pool.remove_item(ability)
	
	for i in 4:
		if upgrade_pool.ability_upgrades.size() == chosen_upgrades.size():
			break
		
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		if chosen_upgrade == null:
			continue
		
		if not chosen_upgrade is AbilityUpgradeCard:
			if chosen_upgrade.level < chosen_upgrade.max_level:
				chosen_upgrades.append(chosen_upgrade)
			continue
			
		if chosen_upgrade.max_level > chosen_upgrade.level:
			chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades

	
func on_upgrade_selected(upgrade:AbilityUpgrade):
	apply_upgrade(upgrade)


func on_level_up(current_level:int):
	var chosen_upgrades = pick_upgrades()
	if chosen_upgrades.size() == 0:
		# Charakter wird geheilt oder bekommt Geld
		return
		
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
