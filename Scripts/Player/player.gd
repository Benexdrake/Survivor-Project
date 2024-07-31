extends CharacterBody2D
class_name Player

@export var health:int
@export var base_damage:int
var max_health:int
@export var max_speed: int
@export var acceleration_smoothing:int
@export var movement_vector:Vector2

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var visuals = $Visuals

var health_regeneration_timer:Timer
var health_regeneration_level:int = 1

var number_colliding_bodies = 0

func _ready():
	health_component.current_health = health
	health_component.max_health = health
	max_health = health
	
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()
	
	
func _process(delta):
	#health_component.current_health = health_component.max_health
	movement_vector = get_movement_vector()
	if movement_vector != Vector2.ZERO:
		$%AnimatedSprite2D.play("1")
	else:
		$%AnimatedSprite2D.pause()
	var direction = movement_vector.normalized()
	
	var move_sign = sign(movement_vector.x)
	
	if move_sign != 0:
		visuals.scale = Vector2(move_sign,1)
		
	var target_velocity = direction * max_speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * acceleration_smoothing))
	move_and_slide()


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement,y_movement)
	

func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()
	

func update_health_display():
	health_bar.value = health_component.get_health_percent()

func on_body_entered(body:Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(body:Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()
	
	
func on_health_changed():
	GameEvents.emit_player_damaged()
	update_health_display()
	$HitStreamPlayer.play()


func on_ability_upgrade_added(ability_upgrade:AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		var scene = ability.ability_controller_scene	
		abilities.add_child(scene.instantiate())
	
	if ability_upgrade.id == "max_health_upgrade":
		health_component.max_health *= 1.20
		update_health_display()
		
	if ability_upgrade.id == "health_regeneration_upgrade":
		health_regeneration_timer = Timer.new()
		health_regeneration_timer.timeout.connect(on_health_regeneration_timer_timeout)
		health_regeneration_timer.wait_time = 0.5
		add_child(health_regeneration_timer)
		health_regeneration_timer.start()
		health_regeneration_level += 1
		
func on_health_regeneration_timer_timeout():
	health_component.current_health += ((max_health / 100) * health_regeneration_level)
	update_health_display()
