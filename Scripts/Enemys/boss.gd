extends CharacterBody2D
class_name Boss

@onready var visuals = $Visuals
@onready var animated_sprite_2d = $Visuals/AnimatedSprite2D
@onready var health_component:HealthComponent = $HealthComponent
@onready var velocity_component:VelocityComponent = $VelocityComponent
@onready var vialdrop_component = $VialDropComponent
@onready var death_component = $DeathComponent
@onready var hit_flash_component = $HitFlashComponent
@onready var knockback_component = $KnockbackComponent
@onready var health_bar = %HealthBar

var knockback_power: int = 50

var move_sign

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
		velocity_component.accelerate_to_player()
		velocity_component.move(self)
	
		move_sign = sign(velocity.x)
		if move_sign != 0:
			visuals.scale = Vector2(-move_sign,1)

func on_hit():
	knockback_component.knockback()
