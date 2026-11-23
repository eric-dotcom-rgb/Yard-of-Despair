extends Resource

class_name QuestData

@export var title: String = "Mission 1°"
@export_multiline var description: String = "-"
@export_multiline var reward: String = "-"

@export var given_seed: Dictionary[CropData, int] = {}

@export var required_crop: Dictionary[CropData, int] = {}

@export var reward_coins: int = 0
@export var reward_emeralds: int = 0
@export var reward_seed: Dictionary[CropData, int] = {}
