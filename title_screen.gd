extends Node2D
"""
Title screen with play, options, and quit buttons.
Handles initial game setup and save data loading.
"""

func _ready() -> void:
	"""Initialize title screen and ensure GameManager has loaded data."""
	# GameManager will handle all save data operations
	GameManager.load_game()
	
func _on_play_pressed() -> void:
	"""Start new game."""
	get_tree().change_scene_to_file("res://scenes/menu_scenes/main_game.tscn")

func _on_quit_pressed() -> void:
	"""Quit game after saving."""
	GameManager.save_game()  # Let GameManager handle saving
	get_tree().quit()

func _on_options_pressed() -> void:
	"""Open options menu."""
	get_tree().change_scene_to_file("res://scenes/menu_scenes/options.tscn")
