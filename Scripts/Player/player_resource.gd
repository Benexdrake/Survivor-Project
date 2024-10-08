extends Resource
class_name PlayerResource

@export var id:String
@export var is_available:bool = false

@export var player_name:String

@export var ability:AbilityUpgradeCard
@export var sprite_frames:SpriteFrames
@export var preview:Texture

@export var hp:int
@export var dmg:float
@export var speed: int
@export var acceleration:int
@export var hp_show:int
@export var dmg_show:float
@export var speed_show: int

@export_multiline var description:String
@export_multiline var stories:Array[String]
