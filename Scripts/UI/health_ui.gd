extends CanvasLayer

@export var heart_full:Texture
@export var heart_half:Texture
@export var heart_empty:Texture

@onready var grid_container = $GridContainer

var max_health:int
var current_health:int

func _ready():
	var player = GlobalVariables.player_resource
	max_health = player.hp
	current_health = player.hp
	
	for i in max_health:
		var heart = TextureRect.new()
		heart.texture = heart_full
		grid_container.add_child(heart)
		
func health_plus():
	max_health += 1
	health_changed(max_health)

func health_changed(health):
	for n in grid_container.get_children():
		grid_container.remove_child(n)
	
	if health >= max_health:
		current_health = max_health
	else:
		current_health += health
	
	for i in current_health:
		var heart = TextureRect.new()
		heart.texture = heart_full
		grid_container.add_child(heart)
		
		
	if current_health < max_health:
		for i in max_health - current_health:
			var heart = TextureRect.new()
			heart.texture = heart_empty
			grid_container.add_child(heart)
