extends Node
class_name DropComponent

var drop_percent:float = 0
var health_component: HealthComponent
@export var drop_scenes: Array[PackedScene]

func _ready():
	pass
	
func config(set_drop_percent:float):
	drop_percent = set_drop_percent
	health_component = owner.health_component
	(health_component as HealthComponent).died.connect(on_died)
	

func on_died(pos):
	for drop_scene in drop_scenes:
		drop(drop_scene)
	
	
func drop(drop_scene):
	var drop_instance = drop_scene.instantiate() as DropScene
	drop_percent = drop_instance.drop_chance
	
	if GlobalVariables.level_resource.drop_chance > 0:
		drop_percent += GlobalVariables.level_resource.drop_chance
	
	var adjusted_drop_percent = drop_percent 
	
	
	if drop_instance.drop_type == "experience":
		var experience_gain_upgrade_count = MetaProgression.get_upgrade_count("experience_gain")
		if experience_gain_upgrade_count > 0:
			adjusted_drop_percent += (experience_gain_upgrade_count * .02)
	
	var rand = randf()
	
	if rand > adjusted_drop_percent:
		return
	
	if drop_scene == null:
		return
		
	if not owner is Node2D:
		return

	var spawn_position = owner.global_position
	get_tree().get_first_node_in_group("entities_layer").add_child(drop_instance)
	drop_instance.global_position = spawn_position
