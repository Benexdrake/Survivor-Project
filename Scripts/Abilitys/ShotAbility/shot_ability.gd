extends CharacterBody2D

@onready var hitbox_component = $HitboxComponent

var _velocity = Vector2(1,0)
var speed = 300



func _physics_process(delta):
	
	
	move_and_collide(_velocity.normalized() * delta * speed)
