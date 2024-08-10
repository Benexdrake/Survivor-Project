extends CanvasLayer

@onready var vignette = $Vignette
@onready var arena_time_ui = $ArenaTimeUI
@onready var experience_bar = $ExperienceBar
@onready var cloud_shadows = $CloudShadows

@export var experience_manager:Node

func set_visibility(visible:bool):
	$ArenaTimeUI.visible = visible
	$ExperienceBar.visible = visible
	$CloudShadows.visible = visible
	$KillCounter.visible = visible
	$HealthUI.visible = visible
	$AbilityUI.visible = visible
	$ArenaWaveUI.visible = visible
	$MoneyUI.visible = visible
