extends PanelContainer
class_name TestPlayerCard

var player_resource:PlayerResource

@onready var character_name_label:Label = %CharacterNameLabel
@onready var preview = %Preview


func create(player:PlayerResource):
	player_resource = player
	character_name_label.text = player_resource.player_name
	preview.texture = player_resource.preview
	%AbilityIcon.texture = player_resource.ability.icon
	
	
	


	

	

	


		


	
