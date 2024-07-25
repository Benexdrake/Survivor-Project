extends Node2D

@onready var hitbox_component : HitboxComponent = $HitboxComponent
@export var timer:Timer

func _ready():
	timer.timeout.connect(on_timer_timeout)

var d := 0.0
var radius = 50.0
var speed = 5.0
#
func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	
	d += delta
	
	position = Vector2(sin(d * speed) * radius, cos(d * speed) * radius ) + player.global_position
	
func on_timer_timeout():
	var abilitys = get_tree().get_nodes_in_group("bible_ability")
	for a in abilitys:
		a.queue_free()
	
