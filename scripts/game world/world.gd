extends Node2D

@onready var dirt_layer: TileMapLayer = $tiles/dirt
@onready var crops_layer: TileMapLayer = $tiles/crops

var active_crops: Dictionary = {}

func change_tile(grid_coord: Vector2i, tile_source_id: int, new_atlas_coord: Vector2i):
	dirt_layer.set_cell(grid_coord, tile_source_id, new_atlas_coord)
 
func plant_crop(grid_coord: Vector2i, crop: CropData) -> void:
	if active_crops.has(grid_coord):
		return
		
	crops_layer.set_cell( grid_coord, crop.soil_wlightgreenplants_id, Vector2i(0,0) )
	active_crops[grid_coord] = {"crop": crop, "stage": 0}
	_grow_cycle(grid_coord, crop)
	
func _grow_cycle(grid_coord: Vector2i, crop: CropData) -> void:
	await get_tree().create_timer(crop.growing_time).timeout
	if not active_crops.has(grid_coord): return
	crops_layer.set_cell( grid_coord, crop.soil_wgreenplants_id, Vector2i(0,0) )
	active_crops[grid_coord]["stage"] = 1
	
	await get_tree().create_timer(crop.growing_time).timeout
	if not active_crops.has(grid_coord):return
	crops_layer.set_cell(grid_coord, crop.crop_id, Vector2i(0,0) )
	active_crops[grid_coord]["stage"] = 2
	
func try_harvest(grid_coord:Vector2i) -> CropData:
	if active_crops.has(grid_coord) and active_crops[grid_coord]["stage"] == 2:
		var harvested_crop = active_crops[grid_coord]["crop"]
		crops_layer.erase_cell(grid_coord)
		active_crops.erase(grid_coord)
		return harvested_crop
	return null

func restore_crop(grid_coord: Vector2i, crop: CropData, stage: int) -> void:
	active_crops[grid_coord] = {"crop": crop, "stage": stage}
	
	if stage == 0:
		crops_layer.set_cell(grid_coord, crop.soil_wlightgreenplants_id, Vector2i(0,0))
		_grow_cycle(grid_coord, crop)
	elif stage == 1:
		crops_layer.set_cell(grid_coord, crop.soil_wgreenplants_id, Vector2i(0,0))
		_grow_from_stage_1(grid_coord, crop)
	elif stage == 2:
		crops_layer.set_cell(grid_coord, crop.crop_id, Vector2i(0,0))
		
func _grow_from_stage_1(grid_coord: Vector2i, crop: CropData) -> void:
	await get_tree().create_timer(crop.growing_time).timeout
	if not active_crops.has(grid_coord):
		return
	crops_layer.set_cell(grid_coord, crop.crop_id, Vector2i(0,0))
	active_crops[grid_coord]["stage"] = 2

func farm(grid_coord:Vector2i) -> CropData:
	if active_crops.has(grid_coord) and active_crops[grid_coord]["stage"] < 2:
		var crop_data= active_crops[grid_coord]["crop"]
		crops_layer.erase_cell(grid_coord)
		active_crops.erase(grid_coord)
		return crop_data
	return null
