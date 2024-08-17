extends TextureRect

@export var menu_parent_path:NodePath
@export var cursor_offset : Vector2

@export var cursor_move: AudioStream
@export var cursor_select: AudioStream

@onready var audio_stream_player = $AudioStreamPlayer


var cursor_index : int = 0

func _ready():
	set_cursor_from_index(0)


func _process(delta):
	var input := Vector2.ZERO
	
	if Input.is_action_just_pressed("move_up"):
		input.y -=1
		set_cursor_from_index(cursor_index+input.y)
	if Input.is_action_just_pressed("move_down"):
		input.y +=1
		set_cursor_from_index(cursor_index+input.y)
	if Input.is_action_just_pressed("move_left"):
		input.x -=1
		set_cursor_from_index(cursor_index+input.x)
	if Input.is_action_just_pressed("move_right"):
		input.x +=1
		set_cursor_from_index(cursor_index+input.x)
		
	if input != Vector2.ZERO:
		audio_stream_player.stream = cursor_move
		audio_stream_player.play()
		
	if Input.is_action_just_pressed("ui_select"):
		var current_menu_item = get_menu_item_at_index(cursor_index)
		if current_menu_item != null:
			if current_menu_item.has_method("cursor_select"):
				current_menu_item.cursor_select()
				audio_stream_player.stream = cursor_select
				audio_stream_player.play()
		

func get_menu_item_at_index(index:int) -> Control:
	print(index)
	return owner.buttons[index]

func set_cursor_from_index(index:int):
	if index >= owner.buttons.size():
		index = 0
		
	if index < 0:
		index = owner.buttons.size()-1
	
	var button := get_menu_item_at_index(index)
	
	if button == null:
		return
		
	var position = button.global_position
	var r_size = button.size
	
	global_position = Vector2(position.x, position.y + r_size.y / 2.0) -(size / 2.0) - cursor_offset
	
	
	cursor_index = index
	
