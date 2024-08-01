extends Node

@export var filler: AbilityUpgrade
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

@export var abilities:Array[Ability]
@export var ability_upgrades:Array[AbilityUpgrade]

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

func _ready():

	
	for ability in abilities:
		if GameEvents.player_resource.ability.id == ability.id:
			continue
		upgrade_pool.add_item(ability, ability.weight)
	
	for ability in ability_upgrades:
		if ability.need_unlock == true:
			continue
		upgrade_pool.add_item(ability, ability.weight)
		
	update_upgrade_pool(GameEvents.player_resource.ability)
	
	experience_manager.level_up.connect(on_level_up)
	
	
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
		
	BgUpgrades.current_upgrades = current_upgrades
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
		
	update_upgrade_pool(upgrade)
	GameEvents.upgrades.append(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade,current_upgrades)
	
# Erweiterbar für Upgrades von Fähigkeiten
func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	for i in ability_upgrades.size():
		if ability_upgrades[i].group_id == chosen_upgrade.group_id:
			upgrade_pool.add_item(ability_upgrades[i], ability_upgrades[i].weight)
			ability_upgrades.remove_at(i)
			break;


func pick_upgrades():
	var chosen_upgrades:Array[AbilityUpgrade] = []
	
	for i in 4:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		if chosen_upgrade != null:
			chosen_upgrades.append(chosen_upgrade)
		
	if chosen_upgrades.size() == 0:
		for i in 4:
			chosen_upgrades.append(filler)
	
	return chosen_upgrades

	
func on_upgrade_selected(upgrade:AbilityUpgrade):
	apply_upgrade(upgrade)


func on_level_up(current_level:int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
