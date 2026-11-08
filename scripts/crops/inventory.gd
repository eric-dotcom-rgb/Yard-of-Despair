extends HBoxContainer

@export var slots_data: Array[CropData] = []
var selected_index: int = 0
var items: Dictionary = {}

func _ready() -> void:
	for crop in slots_data:
		if crop != null:
			items[crop] = {"seeds": 5, "harvested": 0}
	update_ui()

func update_ui() -> void:
	for i in range(get_child_count()):
		var slot_ui: TextureRect = get_child(i)
		var count_label : Label = slot_ui.get_node_or_null("count")
		
		if i < slots_data.size() and slots_data[i] != null:
			var crop = slots_data[i]
			var data = items.get(crop, {"seeds": 0, "harvested": 0})
			
			if data ["harvested"] > 0:
				slot_ui.texture = crop.harvested_icon
			else:
				slot_ui.texture = crop.seed_icon
			if count_label:
				count_label.text = str(data["seeds"]) + "/" + str(data["harvested"])
		else:
			slot_ui.texture = null
			if count_label:
				count_label.text = ""
			
		slot_ui.modulate = Color.WHITE if i == selected_index else Color(0.6, 0.6, 0.6, 0.878)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		selected_index = (selected_index + 1) % get_child_count()
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
	
