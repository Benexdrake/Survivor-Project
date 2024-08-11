extends CharacterBody2D

@onready var hitbox_component = $HitboxComponent
@onready var animation_player = $AnimationPlayer

var _velocity = Vector2(1,0)
var speed = 300

func _ready():
	hitbox_component.area_entered.connect(on_area_entered)
	hitbox_component.body_entered.connect(on_body_entered)
	animation_player.play("start")

func _physics_process(delta):
	move_and_collide(_velocity.normalized() * delta * speed)


func on_area_entered(other):
	queue_free()

func on_body_entered(other):
	$AudioStreamPlayer.play()
	queue_free()
