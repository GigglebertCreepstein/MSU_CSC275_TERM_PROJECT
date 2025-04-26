extends Control
"""
Options menu handling audio settings and high score reset.
"""

#@onready var confirmation_dialog = $ConfirmationDialog

func _ready():
	"""Initialize confirmation dialog."""
#	confirmation_dialog.dialog_text = "Reset ALL high scores?\nThis cannot be undone!"
#	confirmation_dialog.get_ok_button().text = "Reset"
#	confirmation_dialog.get_cancel_button().text = "Cancel"

func _on_back_button_pressed() -> void:
	"""Return to title screen."""
	get_tree().change_scene_to_file("res://scenes/menu_scenes/title_screen.tscn")
	
#func _on_music_toggle_pressed() -> void:
	#"""Toggle music on/off."""
	#GameManager.toggle_music()
#
#func _on_sfx_toggle_pressed() -> void:
	#"""Toggle sound effects on/off."""
	#GameManager.toggle_sfx()
#
#func _on_reset_scores_pressed():
	#"""Show confirmation dialog for score reset."""
	#confirmation_dialog.popup_centered()

#func _on_confirmation_dialog_confirmed():
	#"""Handle confirmed score reset."""
	#GameManager.reset_high_scores()
	#$ResetSound.play()
	
	#play story cutscene
func _on_story_pressed() -> void:
	$menus/story_menu.visible = true
func _on_story_back_button_pressed() -> void:
	$menus/story_menu.visible = false

#display credits
func _on_credits_pressed() -> void:
	$menus/credits_menu.visible = true
func _on_credits_back_button_pressed() -> void:
	$menus/credits_menu.visible = false
	
#display how to play menu
func _on_how_to_play_pressed() -> void:
	$menus/how_to_play_menu.visible = true
func _on_how_to_play_back_button_pressed() -> void:
	$menus/how_to_play_menu.visible = false
