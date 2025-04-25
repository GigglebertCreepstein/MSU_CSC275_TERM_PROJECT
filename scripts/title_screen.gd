extends Node2D
var _save_data : save_data

func _ready() -> void:
	_save_data = save_data.new()
	if  ResourceLoader.exists("user://save_data.tres"):
		_save_data = ResourceLoader.load("user://save_data.tres")
		print(GameManager.high_score, _save_data.high_score)
		if GameManager.high_score > _save_data.high_score:
			_save_data.high_score = GameManager.high_score
		else:	
			GameManager.high_score = _save_data.high_score

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_scenes/main_game.tscn")

func _on_quit_pressed() -> void:
	_save_data.high_score = GameManager.high_score
	ResourceSaver.save(_save_data, "user://save_data.tres")
	get_tree().call_deferred("quit")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_scenes/options.tscn")
