extends CanvasLayer

@onready var resume: Button = $"centercontainer/menu buttons/resume"
@onready var new_game: Button = $"centercontainer/menu buttons/new game"
@onready var exit: Button = $"centercontainer/menu buttons/exit"
@onready var confirmation_dialog: ConfirmationDialog = $"ConfirmationDialog"

var is_paused: bool = false

func _ready() -> void:
	resume.pressed.connect(_on_resume_pressed)
	new_game.pressed.connect(_on_new_game_pressed)
	exit.pressed.connect(_on_exit_pressed)
	confirmation_dialog.confirmed.connect(_on_exit_confirmed)
	var config = ConfigFile.new()
	
	if config.load(SAVE_PATH) == OK:
		resume.visible = true
	else:
		resume.visible = false

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("esc"):
			toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	visible = is_paused
	get_tree().paused = is_paused
	
	if is_paused:
		resume.visible = true
		
	var hud = get_tree().current_scene.get_node_or_null("hud")
	
	if hud:
		hud.visible = not is_paused
		
	if is_paused:
		resume.visible = true

func _on_resume_pressed() -> void:
	resume.release_focus()
	get_tree().paused = false
	is_paused = false
	visible = false
	var hud = get_tree().current_scene.get_node_or_null("hud")
	
	if hud:
		hud.visible = true
		
	if get_tree().current_scene.name !="world":
		get_tree().change_scene_to_file("res://scenes/world.tscn")
		await get_tree().tree_changed
		await get_tree().process_frame
	load_game()

func _on_new_game_pressed() -> void:
	new_game.release_focus()
	var dir = DirAccess.open("user://")
	
	if dir and dir.file_exists("save_game.cfg"):
		dir.remove("save_game.cfg")
		
	get_tree().paused = false
	is_paused = false
	visible = false
	var hud = get_tree().current_scene.get_node_or_null("hud")
	
	if hud:
		hud.visible = true
		
	if get_tree().current_scene.name == "world":
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_exit_pressed() -> void:
	if get_tree().current_scene.name == "world":
		save_game()
	confirmation_dialog.popup_centered()
	
func _on_exit_confirmed() -> void:
	get_tree().quit()


const SAVE_PATH = "user://save_game.cfg"

func save_game():
	var config = ConfigFile.new()
	var current_scene = get_tree().current_scene
	
	#giocatore
	var player = get_tree().current_scene.get_node_or_null("player")
	
	if player:
		config.set_value("player", "position", player.global_position)
	
	#tile modificati
	var dirt_layer = get_tree().current_scene.get_node_or_null("tiles/dirt")
	
	if dirt_layer:
		var tile_saved = {}
		var used_cells = dirt_layer.get_used_cells()
		for cell in used_cells:
			var source_id = dirt_layer.get_cell_source_id(cell)
			tile_saved[var_to_str(cell)] = source_id
		config.set_value("map", "farmed_tiles", tile_saved)
		
	#tile dei crop
	var active_crops_saved = {}
	
	for cell in current_scene.active_crops:
		var data = current_scene.active_crops[cell]
		active_crops_saved[var_to_str(cell)] = {
			"crop_path": data["crop"].resource_path,
			"stage": data["stage"]
		} 
	config.set_value("map", "planted_crops", active_crops_saved)
	
	#inventario per intero(monete, semi, crop e slot attivo
	var hotbar = current_scene.get_node_or_null("hud/hotbar")
	
	if hotbar:
		config.set_value("inventory", "coins", hotbar.coins)
		config.set_value("inventory", "selected_index", hotbar.selected_index)
		var inv_saved = {}
		
		for crop in hotbar.items:
			if crop != null and crop.resource_path != "":
				inv_saved[crop.resource_path] = hotbar.items[crop]
		config.set_value("inventory", "items", inv_saved)
	
	config.save(SAVE_PATH)
	print("game saved on user")

func load_game():
	var config = ConfigFile.new()
	
	if config.load(SAVE_PATH) != OK:
		return
		
	var current_scene = get_tree().current_scene
	
	#giocatore
	var player= get_tree().current_scene.get_node_or_null("player")
	
	if player:
		player.global_position = config.get_value("player", "position", player.global_position)
		
	#tile modificati
	var dirt_layer = get_tree().current_scene.get_node_or_null("tiles/dirt")
	
	if dirt_layer:
		var tile_saved = config.get_value("map", "farmed_tiles", {})
		for cell_str in tile_saved:
			var cell = str_to_var(cell_str)
			var saved_source_id = tile_saved[cell_str]
			dirt_layer.set_cell(cell, saved_source_id, Vector2i(0,0))
	
	#tile dei crop
	var crops_layer = current_scene.get_node_or_null("tiles/crops")
	
	if crops_layer and current_scene.has_method("restore_crop"):
		crops_layer.clear()
		current_scene.active_crops.clear()
		var active_crops_saved = config.get_value("map", "planted_crops", {})
		for cell_str in active_crops_saved:
			var cell: Vector2i = str_to_var(cell_str)
			var info: Dictionary = active_crops_saved[cell_str]
			var crop_res: CropData = load(info["crop_path"])
			if crop_res:
				current_scene.restore_crop(cell, crop_res, info["stage"])
	
	#inventario per intero(monete, semi, crop e slot attivo
	var hotbar = current_scene.get_node_or_null("hud/hotbar")
	
	if hotbar:
		hotbar.coins = config.get_value("inventory", "coins", 0)
		hotbar.selected_index = config.get_value("inventory", "selected_index", 0)
		
		var inv_saved = config.get_value("inventory", "items", {})
		for crop_path in inv_saved:
			var crop_res: CropData = load(crop_path)
			if crop_res:
				hotbar.items[crop_res] = inv_saved[crop_path]
		hotbar.update_ui()
		
	print("game loaded!")
