extends Node2D
class_name DeathComponent

@export var health_component: HealthComponent
var sprite: Sprite2D = Sprite2D.new()

func _ready():
	pass


func config(set_sprite):
	print(set_sprite)
	sprite.texture = set_sprite
	health_component = owner.health_component
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_died)

func on_died(ability_name):
	if owner == null || not owner is Node2D:
		return
	var spawn_position = owner.global_position
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	global_position = spawn_position
	$AnimationPlayer.play("default")
	$HitAudioPlayerComponent.play_ability(ability_name)
