extends Area2D

const MARKET_ROW_SCENE = preload("res://scenes/game world/market row.tscn")

#collega i nodi a HUD
@onready var market_overlay: ColorRect = $"../hud/market side borders"
@onready var xbutton2: TextureButton = $"../hud/market side borders/market window/xbutton2"
@onready var rows_container: VBoxContainer = $"../hud/market side borders/market window/crop rows container"
@onready var hotbar = $"../hud/hotbar"

#inizializzazione
func _ready() -> void:
	market_overlay.visible = false            #chiude finestra del mercato se non chiusa
	body_entered.connect(_on_body_entered)    #collega sensori dell'area
	body_exited.connect(_on_body_exited)
	xbutton2.pressed.connect(close_market)    #collega bottone a funzione
	
	await get_tree().process_frame            #da tempo alla hotbar di inizializzarsi prima di fare le righe
	build_market_rows()

#controlla se il corpo è nell area per aprire finestra
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		market_overlay.visible = true

#controlla se il giocatore esce per chiudere la finestra
func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		close_market()

func close_market() -> void:
	market_overlay.visible = false
 

#costruzione delle righe
func build_market_rows() -> void:
	for child in rows_container.get_children():      #svuota righe di prova/vecchie
		child.queue_free()
		
	for crop in hotbar.slots_data:                  #scorre gli ortaggi salvati nella hotbar
		if crop == null:
			continue
			
		var row = MARKET_ROW_SCENE.instantiate()        #crea una copia nuova della riga grafica e la mette dentro vbox
		rows_container.add_child(row)
		
		if crop.market_row_texture != null:             #sostituisce la riga con quella col nome giusto(per crop)
			row.texture = crop.market_row_texture
			
		row.get_node("crop icon").texture = crop.harvested_icon          #immagine del crop
		row.get_node("sell price label").text = str(crop.sell_price)         #valore del crop in monete
		
		var sell_button: TextureButton = row.get_node("sell")            #collega pulsante sell a funzione sell one crop
		sell_button.pressed.connect(func(): hotbar.sell_one_crop(crop))
		
		var sell_all_button: TextureButton = row.get_node("sell all")      #collega pulsante sell all a funz sell all crop
		sell_all_button.pressed.connect(func(): hotbar.sell_all_crop(crop))
#le funzioni sell one crop e all crop sono nel file della hotbar, siccome deve scalare/aggiunger i numeri da là
