extends CanvasLayer

@export var music:AudioStream

var options_scene = preload("res://Scenes/UI/options_menu.tscn")

func _ready():
	MusicPlayer.stream = music
	MusicPlayer.play()
	%PlayButton.pressed.connect(on_play_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	%UpgradeButton.pressed.connect(on_upgrade_pressed)

func on_play_pressed():
	await ScreenTransition.transition_to_scene("res://Scenes/UI/player_select_screen.tscn")
	
	
func on_options_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))
	self.visible = false
	
	
func on_quit_pressed():
	get_tree().quit()


func on_upgrade_pressed():
	await ScreenTransition.transition_to_scene("res://Scenes/UI/meta_menu.tscn")


func on_options_closed(options_instance:Node):
	self.visible = true
	options_instance.queue_free()


