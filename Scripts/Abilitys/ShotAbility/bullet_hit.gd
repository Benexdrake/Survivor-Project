extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D

func create_bullet(pos, sprite_frames):
	animated_sprite_2d.sprite_frames = sprite_frames
	global_position = pos
	animated_sprite_2d.play("default")
	await animated_sprite_2d.animation_finished
	queue_free()
