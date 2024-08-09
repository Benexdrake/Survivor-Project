extends CharacterBody2D
class_name Player

@export var player_resource:PlayerResource

var player_name:String
var hp:float
var base_dmg:float
var max_health:float
var current_health:float
var max_speed: int
var acceleration_smoothing:int
var movement_vector:Vector2
var _delta

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var visuals = $Visuals

var health_regeneration_timer:Timer
var health_regeneration_level:int = 1
var number_colliding_bodies = 0

func _ready():
	start()
	
	health_component.current_health = hp
	health_component.max_health = hp
	max_health = hp
	
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()
	

func start():
	if GlobalVariables.player_resource != null:
		player_resource = GlobalVariables.player_resource
	else:
		GlobalVariables.player_resource = player_resource
	GlobalVariables.upgrades.append((GlobalVariables.player_resource as PlayerResource).ability)
	player_name = player_resource.player_name
	hp = player_resource.hp
	base_dmg = player_resource.dmg
	max_speed = player_resource.speed
	acceleration_smoothing = player_resource.acceleration
	%AnimatedSprite2D.sprite_frames = player_resource.sprite_frames
	
	var ability_instance = player_resource.ability.ability_controller_scene.instantiate()
	%Abilities.add_child(ability_instance)
	
	var upgrade_manager = get_tree().get_first_node_in_group("upgrade_manager") as UpgradeManager
	if upgrade_manager == null:
		return
	player_resource.ability.level = 1
	upgrade_manager.adding_upgrades(player_resource.ability.id)
	
	$%AnimatedSprite2D.play("default")
	$%AnimatedSprite2D.pause()
	
	(MobileControlLayer.touch_screen_button as TouchScreenButton).released.connect(on_touchscreen_released)
	MobileControlLayer.hide_button()
	
var is_touch = false
	
func _process(delta):
	_delta = delta
	if !is_touch:
		movement_vector = get_movement_vector()
	move()

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if MobileControlLayer.touch_screen_button.is_pressed():
			if !is_touch:
				MobileControlLayer.show_button()
			is_touch = true
			var m_vector = calculate_move_vector(event.position)
			movement_vector = m_vector
			move()


func calculate_move_vector(event_position):
	var texture_center = MobileControlLayer.touch_screen_button.position + Vector2(128,128)
	return (event_position - texture_center).normalized()

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement,y_movement)
	
func move():
	
	if movement_vector != Vector2.ZERO:
		$%AnimatedSprite2D.play("default")
	else:
		$%AnimatedSprite2D.pause()
	var direction = movement_vector.normalized()
	
	var move_sign = sign(movement_vector.x)
	
	if move_sign != 0:
		visuals.scale = Vector2(move_sign,1)
	
	var speed = max_speed
	if is_touch:
			speed = max_speed / 2
	
	var target_velocity = direction * speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-_delta * acceleration_smoothing))
	move_and_slide()

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
	$HitStreamPlayer.play()
	GameEvents.emit_player_damaged()
	update_health_display()


func on_ability_upgrade_added(ability_upgrade:AbilityUpgrade):
	if ability_upgrade is AbilityUpgradeCard:
		var ability = ability_upgrade as AbilityUpgradeCard
		var scene = ability.ability_controller_scene
		abilities.add_child(scene.instantiate())
	
	if ability_upgrade.id == "max_health_upgrade":
		
		hp += max_health * 0.20
		health_component.max_health = hp
		
		health_component.current_health = health_component.max_health
		print(hp)
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

func on_touchscreen_released():
	is_touch = false
	movement_vector = Vector2.ZERO
	MobileControlLayer.hide_button()
