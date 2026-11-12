extends Resource
class_name CropData

@export var crop_name: String = "carrot"
@export var seed_icon: Texture2D
@export var harvested_icon: Texture2D

@export_group("Tilemap crops id")
@export var soil_wgreenplants_id: int = 1
@export var soil_wlightgreenplants_id: int = 0
@export var crop_id: int = 2
@export var seed_price: int = 10

@export var growing_time: float = 15
