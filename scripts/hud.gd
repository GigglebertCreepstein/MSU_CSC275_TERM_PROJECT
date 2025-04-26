extends Control
"""
Heads-up display showing game stats like score, multiplier, and round info.
Handles visual feedback for important events.
"""

# Node References
@onready var score_label: Label = $VBoxContainer/score_label
@onready var previous_high_score_label: Label = $VBoxContainer/previous_high_score_label
@onready var mult_label: Label = $VBoxContainer/mult_label
@onready var round_label: Label = $VBoxContainer/round_label
@onready var timer_label: Label = $VBoxContainer/timer_label
@onready var enemies_label: Label = $VBoxContainer/enemies_label
var is_current_high_score := false

func _ready() -> void:
	"""Connect signals and initialize display."""
	GameManager.update_score_HUD.connect(update_score_label)
	GameManager.update_mult_HUD.connect(update_mult_label)
	GameManager.high_score_updated.connect(_on_high_score_updated)
	previous_high_score_label.text = "Best: %d" % GameManager.high_score

func update_score_label(score_val: int) -> void:
	"""Update the score display with visual feedback."""
	score_label.text = "Score: %d" % score_val
	
	# Visual feedback for high scores
	if is_current_high_score:
		score_label.modulate = Color(1, 0.8, 0)  # Gold color
		create_tween().tween_property(score_label, "modulate", Color(1, 1, 1), 0.5)
	else:
		score_label.modulate = Color(1, 1, 1)  # Normal white

func update_mult_label(mult_val: float) -> void:
	"""Update the multiplier display with visual feedback."""
	mult_label.text = "Multiplier: x%.2f" % mult_val
	mult_label.modulate = Color(0, 1, 0)  # Green flash
	create_tween().tween_property(mult_label, "modulate", Color(1, 1, 1), 0.5)

func update_round_info(round_num: int, time_remaining: float, enemies_remaining: int) -> void:
	"""Update all round-related HUD elements."""
	round_label.text = "Round: %d" % round_num
	timer_label.text = "Time: %d" % ceil(time_remaining)
	enemies_label.text = "Enemies: %d" % enemies_remaining
	
	# Visual feedback on new round
	if round_num > 1:
		round_label.modulate = Color(1, 0.5, 0)  # Orange flash
		create_tween().tween_property(round_label, "modulate", Color(1, 1, 1), 1.0)

func _on_high_score_updated(is_high: bool, score_value: int):
	"""Handle high score updates including visual feedback."""
	previous_high_score_label.text = "Best: %d" % score_value
	
	if is_high:
		# New high score visual feedback
		is_current_high_score = true
		score_label.modulate = Color(1, 0.8, 0)  # Gold
		create_tween().tween_property(score_label, "modulate", Color(1, 1, 1), 0.5)
		
		previous_high_score_label.modulate = Color(0.5, 1, 0.5)  # Light green
		create_tween().tween_property(previous_high_score_label, "modulate", Color(0.7, 0.7, 0.7), 1.0)
	elif score_value == 0:
		# Special case for reset
		is_current_high_score = false
		previous_high_score_label.modulate = Color(1, 0.5, 0.5)  # Light red
		create_tween().tween_property(previous_high_score_label, "modulate", Color(0.7, 0.7, 0.7), 1.0)
