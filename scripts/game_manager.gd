extends Node
"""
Global game state manager handling score, multiplier, and audio settings.
Persists between scenes and manages high scores.
"""

# Signals
signal update_score_HUD(score)
signal update_mult_HUD(mult)
signal high_score_updated(is_high_score: bool, new_high_score: int)

# Game State Variables
var score := 0
var high_score := 0
var multiplier := 1.0
var new_high_score := false

# Audio Bus References
var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")

func update_score(enemy_score_value: int) -> void:
	"""Update score with multiplier bonus."""
	var new_score = score + ceil(enemy_score_value * multiplier)
	var is_high_score = new_score > high_score
	
	score = new_score
	emit_signal("update_score_HUD", score)
	
	if is_high_score:
		high_score = score
		new_high_score = true
		emit_signal("high_score_updated", true, score)
	else:
		emit_signal("high_score_updated", false, high_score)

func update_mult(villager_mult_value: float) -> void:
	"""Update score multiplier."""
	multiplier += villager_mult_value
	emit_signal("update_mult_HUD", multiplier)

func game_over() -> void:
	"""Handle game over sequence."""
	if score > high_score:
		high_score = score
		new_high_score = true
	save_game()
	get_tree().change_scene_to_file("res://scenes/menu_scenes/game_over_menu.tscn")

func toggle_music() -> void:
	"""Toggle music audio bus mute state."""
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))

func toggle_sfx() -> void:
	"""Toggle sound effects audio bus mute state."""
	AudioServer.set_bus_mute(sfx_bus, not AudioServer.is_bus_mute(sfx_bus))

func reset_high_scores() -> void:
	"""Reset all high scores."""
	high_score = 0
	new_high_score = false
	score = 0
	multiplier = 1.0
	save_game()

func save_game() -> void:
	"""Save current high score to file."""
	var save_res = save_data.new()
	save_res.high_score = high_score
	ResourceSaver.save(save_res, "user://save_data.tres")

func load_game() -> void:
	"""Load saved high score from file."""
	if ResourceLoader.exists("user://save_data.tres"):
		var loaded_data = ResourceLoader.load("user://save_data.tres")
		high_score = loaded_data.high_score

func _ready() -> void:
	"""Initialize manager and load saved data."""
	load_game()
