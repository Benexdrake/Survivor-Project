extends CharacterBody2D
@export var max_speed: int
@export var acceleration_smoothing:int


func _ready():
	pass
	
func _process(delta):
	var movement_vector = get_movement_vector()
	if movement_vector != Vector2.ZERO:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.pause()
	var direction = movement_vector.normalized()
	if movement_vector.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif movement_vector.x < 0:
		$AnimatedSprite2D.flip_h = true
		
	var target_velocity = direction * max_speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * acceleration_smoothing))
	move_and_slide()

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement,y_movement)
