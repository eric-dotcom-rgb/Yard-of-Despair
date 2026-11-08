extends TextureRect

@export var slots_data: Array[CropData] = []
var selected_index: int = 0
var items: Dictionary = {}
var coins: int = 0

@onready var crop_icon: TextureRect = $"crop icon"
@onready var slot_num_label: Label = $"slot num"
@onready var seeds_num_label: Label = $"seeds num"
@onready var crop_num_label: Label = $"crop num"
@onready var coins_num_label: Label = $"coins num"

func _ready() -> void:
	for crop in slots_data:
		if crop != null:
			items[crop] = {"seeds": 5, "harvested": 0}
	update_ui()

func update_ui() -> void:
	coins_num_label.text = str(coins)
	slot_num_label.text = str(selected_index + 1)
	
	if selected_index < slots_data.size() and slots_data[selected_index] != null:
		var crop = slots_data[selected_index]
		var data = items.get(crop, {"seeds": 0, "harvested": 0})
		
		crop_icon.texture = crop.harvested_icon if data["harvested"] > 0 else crop.seed_icon
		seeds_num_label.text = str(data["seeds"])
		crop_num_label.text = str(data["harvested"])
	else:
		crop_icon.texture = null
		seeds_num_label.text = "0"
		crop_num_label.text = "0"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode >= KEY_1 and event.keycode <= KEY_6:
			var index= event.keycode - KEY_1
			if index < slots_data.size():
				selected_index = index
				update_ui()

func get_selected_crop() -> CropData:
	if selected_index < slots_data.size():
		var crop = slots_data[selected_index]
		if crop != null and items.has(crop) and items[crop]["seeds"] > 0:
			return crop
	return null
	
func consume_seed(crop: CropData) -> void:
	if items.has(crop) and items[crop]["seeds"] > 0:
		items[crop]["seeds"] -= 1
		update_ui()

func add_harvested(crop: CropData) -> void:
	if not items.has(crop):
		items[crop] = {"seeds": 0, "harvested": 0}
	items[crop]["harvested"] += 1
	update_ui()
	
func add_seed(crop: CropData) -> void:
	if not items.has(crop):
		items[crop] = {"seeds":0, "harvested":0}
	items[crop]["seeds"] += 1
	update_ui()
