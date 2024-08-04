extends Node

@export var end_screen_scene:PackedScene
@export var music:AudioStream
@onready var experience_manager = $ExperienceManager
@onready var ui = $UI

var pause_menu_scene = preload("res://Scenes/UI/pause_menu.tscn")

func _ready():
	MusicPlayer.stream = music
	MusicPlayer.play()
	%Player.health_component.died.connect(on_player_died)
	MobileControlLayer.visible = true
	
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		get_tree().root.set_input_as_handled()


func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
