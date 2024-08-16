extends Node2D

var bee_scene = preload("res://Scenes/Abilitys/HonigwabeAbilityController/honigwabe_ability.tscn")

@onready var bees = $Bees
@onready var shlomo_marker = $Node2D/ShlomoMarker
@onready var kasper_marker = $Node2D/KasperMarker

@export var shlomo_sprite: SpriteFrames
@export var kasper_sprite: SpriteFrames

var shlomo:HonigwabeAbility
var kasper:HonigwabeAbility

var damage_percent:float = .5

func _ready():
	shlomo = create_bee(shlomo, shlomo_sprite)
	kasper = create_bee(kasper, kasper_sprite)
	

func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		queue_free()
		return
	global_position = player.global_position
	bee_position(shlomo,shlomo_marker)
	bee_position(kasper,kasper_marker)
	
func create_bee(bee:HonigwabeAbility, sprite_frames:SpriteFrames):
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	bee = bee_scene.instantiate() as HonigwabeAbility
	bees.add_child(bee)
	bee.animated_sprite_2d.sprite_frames = sprite_frames
	bee.animated_sprite_2d.play("default")
	bee.hitbox_component.damage = player.base_dmg * damage_percent
	return bee

func bee_position(bee:HonigwabeAbility,marker:Marker2D):
	bee.marker = marker
	
	if bee.isWaiting:
		bee.global_position = marker.global_position
