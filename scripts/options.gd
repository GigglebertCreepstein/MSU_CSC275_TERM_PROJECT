extends Control

"""
Options menu controller handling:
- High score display
- Navigation between sub-menus (story, credits, how-to-play)
- High score reset functionality
- Audio settings (via GameManager)
"""

func _ready():
	"""Initialize the options menu when loaded."""
	_update_high_score_display()  # Show current high score on load

### MAIN MENU NAVIGATION ###
func _on_back_button_pressed() -> void:
	"""Return to title screen."""
	get_tree().change_scene_to_file("res://scenes/menu_scenes/title_screen.tscn")

### HIGH SCORE DISPLAY ###
func _update_high_score_display():
	"""Update the high score label with current value from GameManager."""
	$menus/high_score_label.text = "Current High Score: %d" % GameManager.high_score

### SUB-MENU HANDLERS ###

# Story Menu
func _on_story_pressed() -> void:
	"""Show the story cutscene menu."""
	$menus/story_menu.visible = true

func _on_story_back_button_pressed() -> void:
	"""Hide the story cutscene menu."""
	$menus/story_menu.visible = false

# Credits Menu
func _on_credits_pressed() -> void:
	"""Show the credits menu."""
	$menus/credits_menu.visible = true

func _on_credits_back_button_pressed() -> void:
	"""Hide the credits menu."""
	$menus/credits_menu.visible = false

# How-to-Play Menu
func _on_how_to_play_pressed() -> void:
	"""Show the how-to-play instructions menu."""
	$menus/how_to_play_menu.visible = true

func _on_how_to_play_back_button_pressed() -> void:
	"""Hide the how-to-play instructions menu."""
	$menus/how_to_play_menu.visible = false

### HIGH SCORE RESET FUNCTIONALITY ###
func _on_reset_scores_pressed() -> void:
	"""Show confirmation dialog for resetting high scores."""
	$menus/reset_menu.visible = true

func _on_reset_confirmed_pressed() -> void:
	"""
	Reset high scores when confirmed.
	- Updates GameManager
	- Refreshes display
	- Shows feedback message
	"""
	GameManager.reset_high_scores()
	_update_high_score_display()  # Refresh the displayed score
	$menus/reset_menu.visible = false
	
	# Show temporary feedback message
	$menus/reset_feedback.visible = true
	await get_tree().create_timer(3.5).timeout
	$menus/reset_feedback.visible = false

func _on_reset_cancel_pressed() -> void:
	"""Cancel score reset and hide confirmation dialog."""
	$menus/reset_menu.visible = false
