extends CharacterBody2D
class_name BasicEnemy

@onready var visuals = $Visuals
@onready var animated_sprite_2d = $Visuals/AnimatedSprite2D
@onready var health_component:HealthComponent = $HealthComponent
@onready var velocity_component:VelocityComponent = $VelocityComponent
@onready var drop_component = $DropComponent
@onready var death_component = $DeathComponent
@onready var hit_flash_component = $HitFlashComponent
@onready var knockback_component = $KnockbackComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var change_side_component = $ChangeSideComponent

var knockback:float

func _ready():
	$HurtboxComponent.hit.connect(on_hit)

func _process(delta):
	if !knockback_component.isKnockback:
		move()
	
func config(sprite_frames:SpriteFrames, max_health, max_speed, acceleration, drop_percent, knockback_power):
	var texture = sprite_frames.get_frame_texture("default",0)
	knockback = knockback_power
	animated_sprite_2d.sprite_frames = sprite_frames
	health_component.config(max_health)
	velocity_component.config(max_speed, acceleration)
	drop_component.config(drop_percent)
	death_component.config(texture)
	hit_flash_component.config(health_component,texture)
	$Visuals/AnimatedSprite2D.play("default")
	

	
func move():
	if knockback_component.timer.is_stopped():
		velocity_component.accelerate_to_player()
		velocity_component.move(self)
	
		var move_sign = sign(velocity.x)
		if move_sign != 0:
			visuals.scale = Vector2(-move_sign,1)

func on_hit():
	knockback_component.knockback(knockback)
	#velocity = -velocity
	#move_and_slide()
	pass
	#move_and_collide(-velocity * .1)
	#knockback_component.knockback(velocity)
