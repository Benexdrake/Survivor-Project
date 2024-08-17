extends  Node

var save_data: Dictionary = { "meta_upgrade_currency": 0, "meta_upgrades": {} }
const SAVE_FILE_PATH:String = "user://game.save"

func _ready():
	GameEvents.drop_collected.connect(on_drop_collected)
	load_save_file()
	#print(save_data)
	
func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()


func save():
	pass
	#var file = FileAccess.open(SAVE_FILE_PATH,FileAccess.WRITE)
	#file.store_var(save_data)


func add_meta_upgrade(upgrade:MetaUpgrade):
	if !save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity":0
		}
	else:
		save_data["meta_upgrades"][upgrade.id]["quantity"] += 1

func get_upgrade_count(upgrade_id:String):
	if save_data["meta_upgrades"].has(upgrade_id):
		return save_data["meta_upgrades"][upgrade_id]["quantity"]
	else:
		return 0

	
func on_drop_collected(number:float, type:String):
	if type == "money":
		save_data["meta_upgrade_currency"] += number
