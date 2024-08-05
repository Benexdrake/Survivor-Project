extends Node
class_name VialDropComponent

var drop_percent:float = .5
var health_component: HealthComponent
@export var vial_scene: PackedScene

func _ready():
	pass
	
func config(set_drop_percent:float):
	drop_percent = set_drop_percent
	health_component = owner.health_component
	(health_component as HealthComponent).died.connect(on_died)
	

func on_died():
	if randf() > drop_percent + GlobalVariables.level_resource.drop_chance:
		return
	
	if vial_scene == null:
		return
		
	if not owner is Node2D:
		return

	var spawn_position = (owner as Node2D).global_position
	var vial_instance = vial_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("entities_layer").add_child(vial_instance)
	vial_instance.global_position = spawn_position
