extends TextureRect

@export var slots_data: Array[CropData] = []    #crea lista dei .tres modulabili degli ortaggi 
var selected_index: int = 0         #slot selezionato
var items: Dictionary = {}          #magazzino della memoria in cui son salvati i parametri degli ortaggi
var coins: int = 0          #memorizza le monete
var emeralds: int = 0      #smeraldi per uscire

#variabili collegate a hotbar
@onready var crop_icon: TextureRect = $"crop icon"
@onready var slot_num_label: Label = $"slot num"
@onready var seeds_num_label: Label = $"seeds num"
@onready var crop_num_label: Label = $"crop num"
@onready var coins_num_label: Label = $"coins num"
@onready var coin_sound: AudioStreamPlayer = $"coins sound"
@onready var harvest_sound: AudioStreamPlayer = $"harvest sound"
@onready var emeralds_num: Label = $"../emeralds/emeralds num"

#all'inizio del gioco, scorre nel file di salvataggio per riempire il dizionario
func _ready() -> void:
	for crop in slots_data:
		if crop != null:
			items[crop] = {"seeds": crop.starting_seeds, "harvested": 0}
	update_ui()

#sincronizza grafica con dati in memoria
func update_ui() -> void:
	coins_num_label.text = str(coins)              #aggiorna monete
	emeralds_num.text = str(emeralds)       #aggiorna smeraldi
	slot_num_label.text = str(selected_index + 1)    #aggiorna slot
	
	#se lo slot contiene qcosa, lo recupera
	if selected_index < slots_data.size() and slots_data[selected_index] != null:  
		var crop = slots_data[selected_index]
		var data = items.get(crop, {"seeds": 0, "harvested": 0})
		
		crop_icon.texture = crop.harvested_icon if data["harvested"] > 0 else crop.seed_icon    #mostra icona del seme se non hai crops
		seeds_num_label.text = str(data["seeds"])
		crop_num_label.text = str(data["harvested"])
	else:
		crop_icon.texture = null
		seeds_num_label.text = "0"
		crop_num_label.text = "0"

#vede tasti premuti
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode >= KEY_1 and event.keycode <= KEY_6:    #slot degli ortaggi
			var index= event.keycode - KEY_1          #trova numero slot
			if index < slots_data.size():           #e lo ridisegna
				selected_index = index
				update_ui()

#quando semina, viene richiamato da player per controllare se hai semi
func get_selected_crop() -> CropData:
	if selected_index < slots_data.size():
		var crop = slots_data[selected_index]
		if crop != null and items.has(crop) and items[crop]["seeds"] > 0:
			return crop
	return null

#scala di 1 il counter dei semi e quindi aggiorna la grafica 
func consume_seed(crop: CropData) -> void:
	if items.has(crop) and items[crop]["seeds"] > 0:
		items[crop]["seeds"] -= 1
		update_ui()

#aggiunge 1 al counter dei crop e fa effetto sonoro, aggiornando grafica
func add_harvested(crop: CropData) -> void:
	if not items.has(crop):
		items[crop] = {"seeds": 0, "harvested": 0}
	items[crop]["harvested"] += 1
	harvest_sound.play()
	update_ui()

#ti aggiunge 1 seme sia se estirpi uno da terra o se ne compri dallo shop, aggiornando grafica
func add_seed(crop: CropData) -> void:
	if not items.has(crop):
		items[crop] = {"seeds":0, "harvested":0}
	items[crop]["seeds"] += 1
	update_ui()

#aggiunge qtità semi
func add_seed_amount(crop:CropData, amount: int) -> void:
	if crop == null or amount <= 0:
		return
	
	if not items.has(crop):
		items[crop] = {"seeds": 0, "harvested": 0}
	
	items[crop]["seeds"] += amount
	update_ui()

#ti vende 1 ortaggio, se lo hai, e ti da le monete, facendo il suono, aggiornando la grafica.
func sell_one_crop(crop: CropData) -> void:
	if items.has(crop) and items[crop]["harvested"] > 0:
		items[crop]["harvested"] -= 1
		coins += crop.sell_price
		play_coin_sound()
		update_ui()

#controlla se hai ortaggi, calcola il valore degli ortaggi e ti dà, azzera la scorta dei crop e fa il suono, e aggiorna la grafica
func sell_all_crop(crop: CropData) -> void:
	if items.has(crop) and items[crop]["harvested"] > 0:
		var amount: int = items[crop]["harvested"]
		coins += amount * crop.sell_price
		items[crop]["harvested"] = 0
		play_coin_sound()
		update_ui()

#funzione del suono delle monete
func play_coin_sound() -> void:
	if coin_sound:
		coin_sound.play()
