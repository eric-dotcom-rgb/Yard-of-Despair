extends Area2D

const GEM_ROW_SCENE = preload("res://scenes/game world/gems store row.tscn")

@export var gem_packs: Array[GemPackData] = []

@onready var gems_overlay: ColorRect = $"../hud/gems store borders"
@onready var xbutton: TextureButton = $"../hud/gems store borders/gems shop window/xbutton3"
@onready var container: VBoxContainer = $"../hud/gems store borders/gems shop window/gems rows container"
@onready var hotbar: TextureRect = $"../hud/hotbar"

func _ready() -> void:
	gems_overlay.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	xbutton.pressed.connect(close_window)
	
	await get_tree().process_frame
	build_gem_rows()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		gems_overlay.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		gems_overlay.visible = false

func close_window() -> void:
	gems_overlay.visible = false

func build_gem_rows() -> void:
	for child in container.get_children():
		child.queue_free()
	
	for pack in gem_packs:
		if pack == null:
			continue
		
		var row = GEM_ROW_SCENE.instantiate()
		container.add_child(row)
		
		if pack.row_texture != null:
			row.texture = pack.row_texture
		
		row.get_node("price").text = str(pack.coin_price)
		
		var purchase_button: TextureButton = row.get_node("purchase")
		purchase_button.pressed.connect(_on_purchase_pressed.bind(pack))
		

func _on_purchase_pressed(pack: GemPackData) -> void:
		if hotbar.coins >= pack.coin_price:
			hotbar.coins -= pack.coin_price
			hotbar.emeralds += pack.emerald_amount
			hotbar.play_coin_sound()
			hotbar.update_ui()
