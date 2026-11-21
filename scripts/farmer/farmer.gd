extends Area2D

@export var quests: Array[QuestData] = []

var current_mission_index: int = 0
var mission_accepted: bool = false
var player_in_range: bool = false

@onready var hotbar = $"../../hud/hotbar"
@onready var mission: Control = $"../../hud/Mission"
@onready var title: Label = $"../../hud/Mission/Title"
@onready var text: Label = $"../../hud/Mission/MissionText"
@onready var button: TextureButton = $"../../hud/Mission/ActionButton"
@onready var button_label: Label = $"../../hud/Mission/ActionButton/Label"
@onready var label: Label = $"../Label"

func _ready() -> void:
	mission.visible = false
	label.text = "!"
	text_jump_anim()
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	button.pressed.connect(_on_button_pressed)

#animazione punto esclamativo su farmer
func text_jump_anim() -> void:
	var start_y: float = label.position.y
	var tween = create_tween().set_loops()
	tween.tween_property(label, "position:y", start_y -5.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "position:y", start_y, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

#funzione animazione punto esclamativo su farmer, che cambia colore
func _process(_delta: float) -> void:
	#si nasconde se finite missioni
	if current_mission_index >= quests.size():
		label.visible = false
		return          #per spegnere punto esclamativo
	
	#visibile e rosso per missione
	if not mission_accepted:
		label.visible = true
		label.modulate = Color.RED
		return
	
	#missione accettata, quindi se finita diventa giallo
	var q: QuestData = quests[current_mission_index]
	var current_amount: int = 0
	
	if hotbar.items.has(q.target_crop):
		current_amount = hotbar.items[q.target_crop]["harvested"]
	
	if current_amount >= q.required_amount:
		label.visible = true
		label.modulate = Color.DARK_GOLDENROD
	else:
		label.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = true
		if label:
			label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == ("player"):
		player_in_range = false
		mission.visible= false

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event is InputEventKey and event.keycode == KEY_E and event.pressed and not event.echo:
		if mission.visible:
			mission.visible = false
		else:
			open_text()

func open_text() -> void:
	mission.visible = true
	
	if current_mission_index >= quests.size():
		title.text = "George"
		text.text = "You completed the mission!"
		
		if button: 
			button_label.text = "Close"
		return
	
	var q: QuestData = quests[current_mission_index]
	title.text = q.title
	
	if not mission_accepted:
		text.text = q.description
		button_label.text = "Accept"
		return
	
	var current_amount: int = 0
	
	if hotbar.items.has(q.target_crop):
		current_amount = hotbar.items[q.target_crop]["harvested"]
	
	if current_amount >= q.required_amount:
		text.text = q.reward
		button_label.text = "Get reward"
	else:
		text.text = "Go finish your work, then return"
		button_label.text = "Close"

func _on_button_pressed() -> void:
	if current_mission_index >= quests.size():
		mission.visible = false
		return
	
	var q: QuestData = quests[current_mission_index]
	
	if not mission_accepted:
		mission_accepted = true
		mission.visible = false
		return
	
	var current_amount: int = 0
	
	if hotbar.items.has(q.target_crop):
		current_amount = hotbar.items[q.target_crop]["harvested"]
	
	if current_amount >= q.required_amount:
		hotbar.items[q.target_crop]["harvested"] -= q.required_amount
		hotbar.coins += q.reward_coins
		
		if "emeralds" in hotbar and "reward_emeralds" in q:
			hotbar.emeralds += q.reward_emeralds
			
		if hotbar.has_method("add_seeds_amount") and "reward_seed" in q:
			hotbar.add_seeds_amount(q.target_crop, q.reward_seed)
		
		hotbar.play_coin_sound()
		hotbar.update_ui()
		
		current_mission_index += 1
		mission_accepted = false
		mission.visible = false
	else:
		mission.visible = false
