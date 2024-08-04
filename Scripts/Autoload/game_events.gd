extends Node

signal experience_vial_collected(number:float)
signal ability_upgrade_added(upgrade:AbilityUpgrade)
signal player_damaged

var money:int = 0
var player_resource:PlayerResource
var upgrades: Array[AbilityUpgrade]

func emit_experience_vial_collected(number:float):
	experience_vial_collected.emit(number)

func emit_ability_upgrade_added(upgrade:AbilityUpgrade):
	ability_upgrade_added.emit(upgrade)

func emit_player_damaged():
	var player = get_tree().get_first_node_in_group("player") as Player
	if player.health_component.current_health > 0:
		player_damaged.emit()
