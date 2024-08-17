extends Button

@export var hover:AudioStream
@export var press:AudioStream

@onready var audio_stream_player = $AudioStreamPlayer


signal cursor_selected


func cursor_select():
	pressed.emit()

func _ready():
	pressed.connect(on_pressed)
	mouse_entered.connect(on_hover)
	
	
func on_pressed():
	audio_stream_player.stream = press
	audio_stream_player.play()


func on_hover():
	audio_stream_player.stream = hover
	audio_stream_player.play()
	
