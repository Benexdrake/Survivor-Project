extends Node2D
class_name DeathComponent

@export var health_component: HealthComponent
var sprite: Sprite2D = Sprite2D.new()

func _ready():
	pass


func config(set_sprite):
	sprite.texture = set_sprite
	health_component = owner.health_component
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_died)

func on_died():
	if owner == null || not owner is Node2D:
		return
	var spawn_position = owner.global_position
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	global_position = spawn_position
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished
