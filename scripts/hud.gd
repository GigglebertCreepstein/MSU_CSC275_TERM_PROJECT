extends Control
#####GLOBAL VARIABLES/REFERENCES#####
@onready var score_label: Label = $score_label
@onready var mult_label: Label = $mult_label
###########################
func _ready() -> void:
	var connected = GameManager.update_score_HUD.connect(update_score_label)
	GameManager.update_score_HUD.connect(update_score_label)
	GameManager.update_mult_HUD.connect(update_mult_label)

func update_score_label(score_val):
	score_label.text = "Score: " + str(score_val)

func update_mult_label(mult_val):
	mult_label.text = "Multiplier: " + str(mult_val)
