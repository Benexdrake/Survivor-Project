extends Node2D
class_name ClawAbility

@onready var hitbox_component : HitboxComponent = $HitboxComponent
@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.animation_looped.connect(on_animation_looped)
	$AudioStreamPlayer.play()
	
func on_animation_looped():
	queue_free()
