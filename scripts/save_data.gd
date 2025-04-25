class_name save_data extends Resource
@export var high_score = 0

func _init() -> void:
	high_score = GameManager.high_score
