extends HBoxContainer

@export var slots_data: Array[CropData] = []
var selected_index: int = 0


func _ready() -> void:
	update_ui()

func update_ui() -> void:
	for i in range(get_child_count()):
		var slot_ui: TextureRect = get_child(i)
		if i < slots_data.size() and slots_data[i] != null:
			slot_ui.texture = slots_data[i].seed_icon
		else:
			slot_ui.texture = null
			
		slot_ui.modulate = Color.WHITE if i == selected_index else Color(0.6, 0.6, 0.6, 0.878)

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		selected_index = (selected_index + 1) % get_child_count()
		update_ui()

func get_selected_crop() -> CropData:
	if selected_index < slots_data.size():
		return slots_data[selected_index]
	return null
