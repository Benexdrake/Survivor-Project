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
	player_damaged.emit()
