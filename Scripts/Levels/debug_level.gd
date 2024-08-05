extends Node



@onready var arena_time_manager = $Managers/ArenaTimeManager
@onready var enemy_manager = $Managers/EnemyManager
@onready var upgrade_manager = $Managers/UpgradeManager
@onready var experience_manager = $Managers/ExperienceManager
@onready var level = $Level

var pause_menu_scene = preload("res://Scenes/UI/pause_menu.tscn")
var end_screen_scene = preload("res://Scenes/UI/end_screen.tscn")

@export var level_resource:LevelResource

func _ready():
	%Player.health_component.died.connect(on_player_died)
	start()
	
	
func start():
	if GlobalVariables.level_resource != null:
		level_resource = GlobalVariables.level_resource
	else:
		GlobalVariables.level_resource = level_resource
	#MobileControlLayer.visible = true
	arena_time_manager.start(level_resource.map_time)
	enemy_manager.enemy_spawn_phases =level_resource.spawn_phasen
	MusicPlayer.stream = level_resource.music
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
