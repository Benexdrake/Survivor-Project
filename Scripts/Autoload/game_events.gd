extends Node

signal drop_collected(number:float, type:String)
signal ability_upgrade_added(upgrade:AbilityUpgrade)
signal player_damaged

func emit_drop_collected(number:float, type:String):
	drop_collected.emit(number, type)

func emit_ability_upgrade_added(upgrade:AbilityUpgrade):
	ability_upgrade_added.emit(upgrade)

func emit_player_damaged():
	var player = get_tree().get_first_node_in_group("player") as Player
	if player.health_component.current_health > 0:
		player_damaged.emit()
