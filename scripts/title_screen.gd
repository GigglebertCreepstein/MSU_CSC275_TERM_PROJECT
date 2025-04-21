extends Node2D

func _ready() -> void:
	preload("res://scenes/main_game.tscn")

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")
