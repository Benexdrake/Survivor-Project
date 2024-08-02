extends CharacterBody2D
class_name BasicEnemy2

#@export var max_health: float = 10
#@export var max_speed:int
#@export var acceleration:float = 5
#@export_range(0,1) var drop_percent:float = .5
#@export var sprite:Texture

@onready var visuals = $Visuals
@onready var health_component:HealthComponent = $HealthComponent
@onready var velocity_component:VelocityComponent = $VelocityComponent
@onready var vialdrop_component = $VialDropComponent
@onready var death_component = $DeathComponent
@onready var hit_flash_component = $HitFlashComponent
@onready var ability_audio_stream_player_2d_component = $AudioStreamPlayerComponent
@onready var animated_sprite_2d = $Visuals/AnimatedSprite2D
@onready var knockback_component = $KnockbackComponent

@export var knockback_power: int = 5
var is_moving = true

func _ready():
	
	$HurtboxComponent.hit.connect(on_hit)

func _process(delta):
	move()
	
func config(sprite_frames:SpriteFrames, max_health, max_speed, acceleration, drop_percent):
	var texture = sprite_frames.get_frame_texture("default",0)
	
	animated_sprite_2d.sprite_frames = sprite_frames
	health_component.config(max_health)
	velocity_component.config(max_speed, acceleration)
	vialdrop_component.config(drop_percent)
	death_component.config(texture)
	hit_flash_component.config(health_component,texture)
	$Visuals/AnimatedSprite2D.play("default")
	

func move():
	if knockback_component.timer.is_stopped():
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

	
func set_is_moving(moving:bool):
	is_moving = moving
	

func on_hit(hit):
	knockback_component.knockback()
	health_component.hit_sound = hit
	ability_audio_stream_player_2d_component.play_ability(hit)
