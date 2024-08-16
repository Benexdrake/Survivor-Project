extends CharacterBody2D

@onready var hitbox_component = $HitboxComponent
@onready var animation_player = $AnimationPlayer
@onready var max_shoot_timer = $MaxShootTimer

var speed = 300

func _ready():
	max_shoot_timer.timeout.connect(on_max_shoot_timer_timeout)
	$AnimationPlayer.play("shot")


func _process(delta):
	var k_controller = get_tree().get_first_node_in_group("kamehameha_controller") as KamehamehaController
	if k_controller != null:
		global_position = k_controller.marker_2d.global_position
		rotation_degrees = k_controller.rotation_degrees
		move_and_slide()
		
		
func on_max_shoot_timer_timeout():
	queue_free()
