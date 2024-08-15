extends Node
class_name ExperienceManager

signal experience_updated(current_experience:float, target_experience:float, current_level:int)
signal level_up(new_level:int)

const TARGET_EXPERIENCE_GROWTH = 10

var current_experience = 0
var current_level = 1
var target_experience = 10

func _ready():
	GameEvents.drop_collected.connect(on_experience_collected)

func increment_experience(number:int):
	current_experience = min(current_experience + number, target_experience)
	experience_updated.emit(current_experience,target_experience, current_level)
	if current_experience == target_experience:
		current_level +=1
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_experience = 0
		experience_updated.emit(current_experience,target_experience, current_level)
		level_up.emit(current_level)

func on_experience_collected(number:int,type):
	if type == "experience":
		increment_experience(number)
