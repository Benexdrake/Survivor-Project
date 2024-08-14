extends Node

var level_resource: LevelResource

@onready var arena_time_manager = $Managers/ArenaTimeManager
@onready var enemy_manager = $Managers/EnemyManager
@onready var upgrade_manager = $Managers/UpgradeManager
@onready var experience_manager = $Managers/ExperienceManager
@onready var level = $Level

var pause_menu_scene = preload("res://Scenes/UI/pause_menu.tscn")
var end_screen_scene = preload("res://Scenes/UI/end_screen.tscn")

func _ready():
	MusicPlayer.finished.connect(on_music_finished)
	%Player.health_component.died.connect(on_player_died)
	start()
	if level_resource.difficulty == 6:
		%Player.ultra_hardmode()
	
	
func start():
	level_resource = GlobalVariables.level_resource
	MobileControlLayer.visible = true
	arena_time_manager.start(level_resource.map_time)
	enemy_manager.enemy_spawn_phases =level_resource.spawn_phasen
	MusicPlayer.stream = level_resource.music[0]
	MusicPlayer.play()
	level.add_child(level_resource.create_map())
	enemy_manager.on_arena_difficulty_increased(1)
	
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		get_tree().root.set_input_as_handled()


func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	

func on_music_finished():
	var index = randi_range(0,level_resource.music.size()-1)
	MusicPlayer.stream = level_resource.music[index]
