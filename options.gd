extends Control


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
	
#play story cutscene
func _on_story_pressed() -> void:
	pass # Replace with function body.
	

#display credits
func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_music_toggle_pressed() -> void:
	GameManager.toggle_music()

func _on_sfx_toggle_pressed() -> void:
	pass # Replace with function body.
