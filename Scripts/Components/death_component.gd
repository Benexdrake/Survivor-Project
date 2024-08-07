extends Node2D
class_name DeathComponent

@export var health_component: HealthComponent
@onready var sprite = $Sprite2D


func config(set_sprite):
	sprite.texture = set_sprite
	health_component = owner.health_component
	health_component.died.connect(on_died)


func on_died(pos):
	if owner == null || not owner is Node2D:
		return
	sprite.visible = true
		
	var spawn_position = owner.global_position
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	global_position = pos
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished
