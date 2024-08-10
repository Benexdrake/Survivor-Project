extends PanelContainer
class_name AbilityPanelCard

var has_icon:bool = false

func add_icon(icon:Texture):
	$MarginContainer/TextureRect.texture = icon
	has_icon = true
