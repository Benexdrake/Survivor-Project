extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]
@export var randomize_pitch = true
@export var min_pitch = .9
@export var max_pitch = 1.1

func play_ability(ability_name):
	#match ability_name:
		#"SlashAbility":
			#stream = streams[0]
		#"ClawAbility":
			#stream = streams[1]
		#"ThunderAbility":
			#stream = streams[2]
		#"BibleAbility":
			#stream = streams[3]
		#"JudismAuraAbility":
			#stream = streams[4]
			#
	#if randomize_pitch:
		#pitch_scale = randf_range(min_pitch,max_pitch)
	#else:
		#pitch_scale = 1
			
	play()
