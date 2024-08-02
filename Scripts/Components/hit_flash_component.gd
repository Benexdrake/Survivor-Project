extends Node

var health_component: HealthComponent
var sprite: Sprite2D = Sprite2D.new()
@export var hit_flash_material:ShaderMaterial

var hit_flash_tween: Tween

func _ready():
	pass
	

func config(set_health_component: HealthComponent, set_sprite):
	health_component = set_health_component
	sprite.texture = set_sprite
	health_component.health_changed.connect(on_health_changed)
	sprite.material = hit_flash_material
	
func on_health_changed():
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
		
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, .3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
