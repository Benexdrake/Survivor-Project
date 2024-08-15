extends CharacterBody2D

@onready var hitbox_component = $HitboxComponent
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

@export var sprite_frames:SpriteFrames

var bullet_hit = preload("res://Scenes/Abilitys/ShotAbility/bullet_hit.tscn")

var _velocity = Vector2(1,0)
var speed = 300

func _ready():
	hitbox_component.area_entered.connect(on_area_entered)
	hitbox_component.body_entered.connect(on_body_entered)
	timer.timeout.connect(on_timer_timeout)
	animation_player.play("start")

func _physics_process(delta):
	move_and_collide(_velocity.normalized() * delta * speed)


func on_area_entered(other):
	$AudioStreamPlayer.play()
	
	var bullet = bullet_hit.instantiate()
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	foreground.add_child(bullet)
	bullet.create_bullet(other.global_position, sprite_frames)

func on_body_entered(other):
	pass
	
	
	
	#queue_free()


func on_timer_timeout():
	queue_free()
