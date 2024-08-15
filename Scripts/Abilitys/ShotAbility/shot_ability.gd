extends CharacterBody2D

@onready var hitbox_component = $HitboxComponent
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var sprite_2d = $Sprite2D

@export var sprite_frames:SpriteFrames

var bullet_hit = preload("res://Scenes/Abilitys/ShotAbility/bullet_hit.tscn")

var _velocity = Vector2(1,0)
var speed = 500

@export var max_collisions:int = 0
var collisions:int = 0

func _ready():
	visible_on_screen_notifier_2d.screen_exited.connect(on_exit)
	
	hitbox_component.area_entered.connect(on_area_entered)
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
	
	
func on_exit():
	collision()


func collision():
	if collisions < max_collisions:
		var rotated = randf_range(-PI,PI)
		var random_direction = Vector2.RIGHT.rotated(rotated)
		_velocity = -_velocity + random_direction
		collisions+=1
		sprite_2d.flip_h = !sprite_2d.flip_h
	else:
		queue_free()

func on_timer_timeout():
	queue_free()
