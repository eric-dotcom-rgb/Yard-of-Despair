extends ColorRect

const SETTINGS_PATH = "user://settings.cfg"

@onready var dont_show_check: CheckBox = $"window/VBoxContainer/dont show"
@onready var ok_button: BaseButton = $window/VBoxContainer/ok

func _ready() -> void:
	ok_button.pressed.connect(_on_ok_pressed)
	
	var config = ConfigFile.new()
	#controlla se gia spuntato
	if config.load(SETTINGS_PATH) == OK:
		if config.get_value("tutorial", "hide_controls", false) == true:
			visible = false
			return
	
	visible = true

func _on_ok_pressed() -> void:
	#salva preferenza
	if dont_show_check.button_pressed:
		var config = ConfigFile.new()
		config.load(SETTINGS_PATH)
		config.set_value("tutorial", "hide_controls", true)
		config.save(SETTINGS_PATH)
		
	visible = false
