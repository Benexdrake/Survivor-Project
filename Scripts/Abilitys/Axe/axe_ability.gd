extends Node2D
class_name AxeAbility

@onready var hitbox_component = $HitboxComponent
@onready var sprite_2d = $Sprite2D

func _ready():
	pass

func start(pos, damage):
	if hitbox_component != null:
		hitbox_component.damage = damage
	
	var player = get_tree().get_first_node_in_group("player") as Player
	var tween_up = create_tween()
	
	tween_up.set_parallel(true)
	
	var x = randf_range(pos.x - 100,pos.x + 100)
	
	tween_up.finished.connect(down.bind(pos))
	tween_up.tween_property(sprite_2d,"rotation",deg_to_rad(360),.5)
	tween_up.tween_property(self,"position",Vector2(x,pos.y -100),.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween_up.chain()
	
	
func down(pos):
	var tween_down = create_tween()
	tween_down.set_parallel()
	tween_down.tween_property(self,"rotation",deg_to_rad(2160),3.0)
	tween_down.tween_property(self,"position",Vector2(pos.x,pos.y + 500),3.0)
	tween_down.chain()
	await tween_down.finished
	queue_free()
