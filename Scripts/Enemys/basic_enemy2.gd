extends CharacterBody2D
class_name BasicEnemy2

@export var max_health: float = 10
@export var max_speed:int
@export var acceleration:float = 5
@export_range(0,1) var drop_percent:float = .5
@export var sprite:Texture

@onready var visuals = $Visuals
@onready var sprite2D:Sprite2D = $Visuals/Sprite2D
@onready var health_component:HealthComponent = $HealthComponent
@onready var velocity_component:VelocityComponent = $VelocityComponent
@onready var vialdrop_component = $VialDropComponent
@onready var death_component = $DeathComponent
@onready var hit_flash_component = $HitFlashComponent

var timer = Timer.new()

var is_moving = true

func _ready():
	config()

func _process(delta):
	var rand = randf_range(0,20)
	if rand < 15:
		set_is_moving(false)
	else:
		set_is_moving(true)
		
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
		
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign,1)
	
func config():
	sprite2D.texture = sprite
	health_component.config(max_health)
	velocity_component.config(max_speed, acceleration)
	vialdrop_component.config(drop_percent)
	death_component.config(sprite2D)
	hit_flash_component.config(health_component,sprite2D)
	
func set_is_moving(moving:bool):
	is_moving = moving
	

