extends Resource
class_name EnemyResource

@export var enemy_scene: PackedScene
@export var sprite_frames:SpriteFrames
@export var id:String
@export var max_health: float
@export var max_speed:int
@export var acceleration:float
@export var knockback_power:float
@export_range(0,1) var drop_percent:float
@export var weight:int

func create_enemy(pos, node:Node):
	var enemy = enemy_scene.instantiate() as Node2D
	if enemy is FriendlyEnemy:
		return
	node.add_child(enemy)
	enemy.global_position = pos
	enemy.config(sprite_frames, max_health, max_speed, acceleration, drop_percent, knockback_power)
