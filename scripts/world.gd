extends Node2D

@onready var dirt_layer: TileMapLayer = $tiles/dirt

func change_tile(grid_coord: Vector2i, tile_source_id: int, new_atlas_coord: Vector2i):
	dirt_layer.set_cell(grid_coord, tile_source_id, new_atlas_coord)
