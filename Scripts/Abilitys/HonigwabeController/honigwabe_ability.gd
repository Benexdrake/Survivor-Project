extends CharacterBody2D
class_name HonigwabeAbility
@onready var animated_sprite_2d = %AnimatedSprite2D
@onready var hitbox_component = $HitboxComponent

@onready var attack_timer = $AttackTimer
@onready var collision_check_timer = $CollisionCheckTimer

var marker:Marker2D

var isWaiting:bool = true
var isAttacking:bool = false
var canAttack:bool = true

const MAX_RANGE = 100

var max_speed:int = 200
var acceleration:int = 100

var enemy:BasicEnemy

var enemy_global_position = Vector2.ZERO

func _ready():
	attack_timer.timeout.connect(on_timer_timeout)
	collision_check_timer.timeout.connect(on_collision_check_timer_timeout)
	hitbox_component.area_entered.connect(on_enemy_area_entered)
	
	
	
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
func _process(delta):
	if isAttacking:
		accelerate_to_marker()
		return
		
	if !canAttack:
		return
	looking_for_enemy()
		
	if enemy != null:
		accelerate_to_enemy()
	
	if isWaiting:
		move(global_position.x)
	else:
		move(velocity.normalized().x)

func looking_for_enemy():
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
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
		isWaiting = false
		if enemies.size() > 1:
			enemy = enemies[randi_range(0,1)]
		else:
			enemy = enemies[0]


func move(x):
	#if isWaiting:
	#if x > 0:
		#animated_sprite_2d.flip_h = false
	#elif x < 0:
		#animated_sprite_2d.flip_h = true
		
	
	var move_sign = sign(x)
	
	if move_sign != 0:
		animated_sprite_2d.scale = Vector2(move_sign,1)
		
		
func accelerate_to_enemy():
	var direction = (enemy.global_position -  global_position).normalized()
	accelerate_in_direction(direction)


func accelerate_to_marker():
	var m_pos = marker.global_position
	var pos = global_position
	
	if m_pos - Vector2(10, 10) <= pos && m_pos + Vector2(10, 10) >= pos:
		isAttacking = false
		isWaiting = true
		
	var direction = (m_pos -  pos).normalized()
	var desired_velocity = direction * (max_speed * 2)
	velocity = velocity.lerp(desired_velocity,1 - exp(-acceleration * get_process_delta_time()))
	move_and_slide()


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity,1 - exp(-acceleration * get_process_delta_time()))
	move_and_slide()
	
	
func on_timer_timeout():
	canAttack = true
	

func on_collision_check_timer_timeout():
	%CollisionShape2D.set_deferred("disabled",false)
	
func on_enemy_area_entered(enemy_area):
	attack_timer.start()
	isAttacking = true
	canAttack = false
	%CollisionShape2D.set_deferred("disabled",true)
	collision_check_timer.start()
