extends CharacterBody2D
class_name FriendlyEnemy

@onready var life_timer = $LifeTimer
@onready var hitbox_component = $HitboxComponent
@onready var attack_rate_timer = $AttackRateTimer
@onready var collision_shape_2d = $HitboxComponent/CollisionShape2D
@onready var attack_span_timer = $AttackSpanTimer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var shadow_animated_sprite_2d = $ShadowAnimatedSprite2D

@export var max_speed: int = 100
@export var acceleration: float = 20
@export var damage_percent: float = .5

var enemy_global_position = Vector2.ZERO

var animation:int = 0

var enemy: BasicEnemy

const MAX_RANGE = 300

func _ready():
	life_timer.timeout.connect(on_life_time_timeout)
	attack_rate_timer.timeout.connect(on_attack_rate_timer_timeout)
	attack_span_timer.timeout.connect(on_attack_span_timer_timeout)
	var player = get_tree().get_first_node_in_group("player") as Player
	if player != null:
		hitbox_component.damage = player.base_dmg * damage_percent
		
	var variants = animated_sprite_2d.sprite_frames.get_animation_names()
	
	animation = randi_range(0,variants.size()-1)
	animated_sprite_2d.play(str(animation))
	shadow_animated_sprite_2d.play(str(animation))
	var size = (animated_sprite_2d.sprite_frames as SpriteFrames).get_frame_texture(str(animation),0).get_size()
	#animated_sprite_2d.offset.y = -(size.y/2)
	
	

func _process(delta):
	if enemy != null:
		enemy_global_position = enemy.global_position
	else:
		enemy = find_enemy()
		
	if enemy_global_position != Vector2.ZERO:
		move()

func move():
	accelerate_to_next_enemy()
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		animated_sprite_2d.play(str(animation))
		shadow_animated_sprite_2d.play(str(animation))
		animated_sprite_2d.scale = Vector2(-move_sign,1)
		shadow_animated_sprite_2d.scale = Vector2(-move_sign,1)
	else:
		animated_sprite_2d.stop()
		shadow_animated_sprite_2d.stop()

func accelerate_to_next_enemy():
	if enemy_global_position == null:
		return
		
	var direction = (enemy_global_position - global_position).normalized()
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))
	
	move_and_slide()


	
func find_enemy():
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(e: Node2D):
		return e.global_position.distance_squared_to(global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(global_position)
		var b_distance = b.global_position.distance_squared_to(global_position)
		return a_distance < b_distance
	)
	
	if enemies.size() > 0:
		return enemies[0]
	return null
	
	
func on_life_time_timeout():
	queue_free()
	
func on_attack_rate_timer_timeout():
	collision_shape_2d.disabled = false
	attack_span_timer.start()
	
func on_attack_span_timer_timeout():
	collision_shape_2d.disabled = true
