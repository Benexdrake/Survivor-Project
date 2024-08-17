extends CanvasLayer
@onready var label = %Label

@onready var grid_container = %GridContainer
@onready var purchase_button = %PurchaseButton

@export var all_meta_upgrades:AllMetaUpgradesResource

var meta_upgrade_card_scene = preload("res://Scenes/UI/meta_upgrade_card.tscn")

var selected_meta_upgrade:MetaUpgrade

func _ready():
	MetaProgression.save_data["meta_upgrade_currency"] = 100
	%BackButton.pressed.connect(on_back_button_pressed)
	purchase_button.disabled = true
	purchase_button.button_down.connect(on_button_clicked)
	for upgrade in all_meta_upgrades.meta_upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_upgrade(upgrade)


func on_button_clicked():
	on_purchase_pressed()
	get_tree().call_group("meta_upgrade_card", "update_progress")
		
	var quantity = MetaProgression.save_data["meta_upgrades"][selected_meta_upgrade.id]["quantity"]
	if selected_meta_upgrade.max_quantity == quantity:
		purchase_button.disabled = true
		purchase_button.text = "MAX"
		return
		

func on_purchase_pressed():
	MetaProgression.add_meta_upgrade(selected_meta_upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= selected_meta_upgrade.cost
	MetaProgression.save()
	if selected_meta_upgrade.cost > MetaProgression.save_data["meta_upgrade_currency"]:
		purchase_button.disabled = true
		return


func on_back_button_pressed():
	await ScreenTransition.transition_to_scene("res://Scenes/UI/main_menu.tscn")
