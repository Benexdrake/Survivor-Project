class_name UpgradeWeightedTable

var ability_upgrades:Array[AbilityUpgrade] = []
var weight_sum = 0


func add_item(ability:AbilityUpgrade):
	ability_upgrades.append(ability)
	weight_sum += ability.weight


func remove_item(ability: AbilityUpgrade):
	if ability.level == ability.max_level:
		for i in ability_upgrades.size():
			if ability_upgrades[i].id == ability.id:
				ability_upgrades.remove_at(i)
				break
	weight_sum = 0
	for a in ability_upgrades:
		weight_sum += a.weight


func pick_item(exclude: Array = []):
	var adjusted_abilities: Array[AbilityUpgrade] = ability_upgrades
	var adjusted_weight_sum = weight_sum
	
	if exclude.size() > 0:
		adjusted_abilities = []
		adjusted_weight_sum = 0
		for ability in ability_upgrades:
			if ability in exclude:
				continue
			adjusted_abilities.append(ability)
			adjusted_weight_sum += ability.weight
	
	var item = find_item(adjusted_weight_sum,adjusted_abilities)
	
	return item
			
func find_item(adjusted_weight_sum, adjusted_abilities):
	#var chosen_weight = randi_range(1, adjusted_weight_sum)
	
	var index = randi_range(0, adjusted_abilities.size() -1)
	return adjusted_abilities[index]
	
	#var iteration_sum = adjusted_weight_sum
	#
	#var item
	#
	#for ability in adjusted_abilities:
		#if chosen_weight <= iteration_sum:
			#if ability.level < ability.max_level:
				#item = ability
				#break
	
	#if item == null:
		#item = adjusted_abilities[randi_range(0, adjusted_abilities.size() - 1)]
	
	#return item
