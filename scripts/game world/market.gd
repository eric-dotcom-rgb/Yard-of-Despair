extends Area2D

const MARKET_ROW_SCENE = preload("res://scenes/game world/market row.tscn")

@onready var market_overlay: ColorRect = $"../hud/market side borders"
@onready var xbutton2: TextureButton = $"../hud/market side borders/market window/xbutton2"
@onready var rows_container: VBoxContainer = $"../hud/market side borders/market window/crop rows container"
@onready var hotbar = $"../hud/hotbar"

func _ready() -> void:
	market_overlay.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	xbutton2.pressed.connect(close_market)
	
	await get_tree().process_frame
	build_market_rows()
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		market_overlay.visible = true
		
func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		close_market()
		
func close_market() -> void:
	market_overlay.visible = false
	
func build_market_rows() -> void:
	for child in rows_container.get_children():
		child.queue_free()
		
	for crop in hotbar.slots_data:
		if crop == null:
			continue
			
		var row = MARKET_ROW_SCENE.instantiate()
		rows_container.add_child(row)
		
		if crop.market_row_texture != null:
			row.texture = crop.market_row_texture
			
		row.get_node("crop icon").texture = crop.harvested_icon
		row.get_node("sell price label").text = str(crop.sell_price)
		
		var sell_button: TextureButton = row.get_node("sell")
		sell_button.pressed.connect(func(): hotbar.sell_one_crop(crop))
		
		var sell_all_button: TextureButton = row.get_node("sell all")
		sell_all_button.pressed.connect(func(): hotbar.sell_all_crop(crop))
