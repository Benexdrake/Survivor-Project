extends Node2D

@onready var hitbox_component : HitboxComponent = $HitboxComponent
@onready var sprite = $AnimatedSprite2D
@onready var collision_shape_2d = $HitboxComponent/CollisionShape2D

var interval:bool

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	$IntervalTimer.timeout.connect(on_intervaltimer_timeout)
	interval = collision_shape_2d.disabled
	
func on_timer_timeout():
	queue_free()

func on_intervaltimer_timeout():
	collision_shape_2d.disabled = !interval
	interval = collision_shape_2d.disabled
