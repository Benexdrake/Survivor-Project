extends PanelContainer

@onready var texture_rect = %TextureRect

@onready var name_label: Label = %NameLabel

@export var uncheck_texture:Texture
@export var check_texture:Texture

@export var check_rect_textures : Array[TextureRect]

var meta_upgrade:MetaUpgrade

func _ready():
	gui_input.connect(on_gui_input)

	
func select_card():
	$AnimationPlayer.play("selected")
	var meta_menu = get_tree().get_first_node_in_group("meta_menu")
	if meta_menu == null:
		return
	
	meta_menu.label.text = meta_upgrade.description
	meta_menu.purchase_button.text = str(meta_upgrade.cost)
	
	if meta_upgrade.cost > MetaProgression.save_data["meta_upgrade_currency"]:
		meta_menu.purchase_button.disabled = true
		return
	
	var quantity = MetaProgression.save_data["meta_upgrades"][meta_upgrade.id]["quantity"]
	
	if meta_upgrade.max_quantity == quantity:
		meta_menu.purchase_button.disabled = true
		return
	
	meta_menu.purchase_button.disabled = false
	meta_menu.selected_meta_upgrade = meta_upgrade
	
	
		

	

func set_upgrade(upgrade: MetaUpgrade):
	if upgrade != null:
		texture_rect.texture = upgrade.icon
		name_label.text = upgrade.title
		meta_upgrade = upgrade
	
	if !MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		MetaProgression.add_meta_upgrade(upgrade)
		
	update_progress()


func update_progress():
	var quantity = MetaProgression.save_data["meta_upgrades"][meta_upgrade.id]["quantity"]
	
	for i in quantity:
		check_rect_textures[i].visible = true
		check_rect_textures[i].texture = check_texture
	
	for i in meta_upgrade.max_quantity - quantity:
		check_rect_textures[i].visible = true


func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		select_card()
