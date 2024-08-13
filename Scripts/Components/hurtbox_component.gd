extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: Node

var floating_text_scene = preload("res://Scenes/UI/floating_text.tscn")

func _ready():
	area_entered.connect(on_area_entered)
	
	
func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
		
	if health_component == null:
		return
		
	var check = owner.change_side_component.check_speech(other_area.owner.name)
	if check:
		return
	
	var hitbox_component = other_area as HitboxComponent
	
	var dmg = hitbox_component.damage
	
	var damage = round_to_dec(randf_range(dmg - 2, dmg + 1),2)

	health_component.damage(damage)
	var floating_text = floating_text_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + (Vector2.UP * 16)
	floating_text.start(dmg, damage)
	
	hit.emit()


func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
