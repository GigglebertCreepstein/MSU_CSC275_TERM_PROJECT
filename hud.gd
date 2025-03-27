extends Control
#####GLOBAL VARIABLES/REFERENCES#####
@onready var score_label: Label = $Score
@onready var multiplier_label: Label = $multiplier
var score = 0
var multiplier = 1.0
###########################
func _ready() -> void:
	score_label.text = "SCORE: 0"

func update_score(score_val):
	pass
