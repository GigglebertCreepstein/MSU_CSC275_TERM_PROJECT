extends Control

func _ready():
	# Display the current high score when the options menu loads
	_update_high_score_display()

func _update_high_score_display():
	# Update the label with the current high score
	$menus/high_score_label.text = "Current High Score: %d" % GameManager.high_score
	
func _on_back_button_pressed() -> void:
	"""Return to title screen."""
	get_tree().change_scene_to_file("res://scenes/menu_scenes/title_screen.tscn")

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

# Add reset high scores functionality
func _on_reset_scores_pressed() -> void:
	"""Show confirmation dialog for resetting high scores."""
	$menus/reset_menu.visible = true

func _on_reset_confirmed_pressed() -> void:
	"""Reset high scores when confirmed."""
	GameManager.reset_high_scores()
	_update_high_score_display()  # Update the display after reset
	$menus/reset_menu.visible = false
	# Show feedback that scores were reset
	$menus/reset_feedback.visible = true
	await get_tree().create_timer(3.5).timeout
	$menus/reset_feedback.visible = false

func _on_reset_cancel_pressed() -> void:
	"""Cancel score reset."""
	$menus/reset_menu.visible = false
