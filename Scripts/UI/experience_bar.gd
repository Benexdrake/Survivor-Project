extends CanvasLayer

var experience_manager:Node
@onready var progress_bar = %ProgressBar

func _ready():
	experience_manager = owner.experience_manager
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)
	

func on_experience_updated(current_experience: float, target_experience:float, current_level:int):
	var percent = current_experience / target_experience
	progress_bar.value = percent
