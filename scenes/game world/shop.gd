extends Area2D

const SHOP_ROW_SCENE = preload("res://scenes/game world/shop crop rows.tscn")

@onready var shop_side_borders: ColorRect = $"../hud/shop side borders"
@onready var shop_window: TextureRect = $"../hud/shop side borders/shop window"
@onready var xbutton: TextureButton = $"../hud/shop side borders/shop window/xbutton"
@onready var rows_container: VBoxContainer = $"../hud/shop side borders/shop window/crop rows container"
@onready var hotbar = $"../hud/hotbar"

func _ready() -> void:
	shop_side_borders.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	xbutton.pressed.connect(close_shop)
	
	await get_tree().process_frame
	build_shop_rows()
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		open_shop()
		
func open_shop() -> void:
	shop_side_borders.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		close_shop()
		
func close_shop() -> void:
	shop_side_borders.visible = false

func build_shop_rows() -> void:
	for child in rows_container.get_children():
		child.queue_free()
		
	for crop in hotbar.slots_data:
		if crop == null:
			continue
			
		var row = SHOP_ROW_SCENE.instantiate()
		rows_container.add_child(row)
		if crop.shop_row_texture != null:
			row.texture = crop.shop_row_texture
		
		row.get_node("seed icon").texture = crop.seed_icon
		row.get_node("price label").text = str(crop.seed_price)
		
		var plus_btn: TextureButton= row.get_node("buy button")
		plus_btn.pressed.connect(_on_buy_pressed.bind(crop))
		
func _on_buy_pressed(crop: CropData) -> void:
	if hotbar.coins >= crop.seed_price:
		hotbar.coins -= crop.seed_price
		hotbar.add_seed(crop)
	else:
		print("non abbastanza monete")
	
