extends Node
signal update_score_HUD(score)
signal update_mult_HUD(mult)
var score = 0
var high_score = 0
var multiplier = 1.0
var new_high_score = false
var music_bus = AudioServer.get_bus_index("music")
var sfx_bus = AudioServer.get_bus_index("sound effects")
var music_sound_on = true
var sfx_sound_on = true
func update_score(enemy_score_value):
	score = score + (enemy_score_value * multiplier)
	update_score_HUD.emit(score)
	
	
func update_mult(villager_mult_value):
	multiplier += villager_mult_value
	update_mult_HUD.emit(multiplier)

func game_over():
	if score > high_score:
		high_score = score
		new_high_score = true
	get_tree().call_deferred("change_scene_to_file","res://scenes/game_over_menu.tscn")
	
func toggle_music():
	if music_sound_on:
		AudioServer.set_bus_mute(music_bus, false)
	else:
		AudioServer.set_bus_mute(music_bus, true)
		music_sound_on = true
