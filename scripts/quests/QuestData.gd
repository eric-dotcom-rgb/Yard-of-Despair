extends Resource

class_name QuestData

@export var title: String = "Mission 1°"
@export_multiline var description: String = "-"
@export_multiline var reward: String = "-"
@export var target_crop: CropData
@export var required_amount: int = 0
@export var reward_coins: int = 0
@export var reward_emeralds: int = 0

@export var reward_seed_crop: CropData
@export var reward_seed: int = 0
