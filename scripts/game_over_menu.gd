extends Node2D

var flavor_text_fail = ["“I shall ne’er meet my fall by the likes of you.”",
"“Alas, mine vengeance shall not be denied.”",
"“For many a year have I fought, and for many more shall I prevail.\nTill no children of the night are harmed henceforth.”",
"“The Kingdom of Valor shall never sunder our spirit.”",
"“All that hath wrought, I wrought for thee, my beloved son. May thy slumber be eternally peaceful”.",
"“‘Tis but a trifle against the horrors beset upon my kin.”",
"“We shall feast tonight.”",
"“Why doth yonder kingdom persist in sending numbskulls clad in iron?\n This one bore naught but a stick.”",
"“No justice lies in wanton bloodshed. Depart henceforth, and burden these lands no more.”",
"“Mere slime, how darest thou call thineself a warrior?”"]

var flavor_text_success = ["""Thoust has proven thine mettle. Take mine life as a tribute, rise as a champion of the realm.
Permit me at last to join my son in the melodious halls beyond.""","""Alas, I shall retreat.\nFor on this day I met a spirit brave gallant to brave mine trials with unyielding valor."""]

func _ready() -> void:
	if GameManager.new_high_score:
		GameManager.new_high_score = false
		$"Fanfare-46385".play()
		$labels/flavor_text.text = flavor_text_success[randi_range(0,1)]
		$labels/score.text = "Score: " + str(GameManager.score)
		$labels/high_score.visible = false
		$labels/new_high_score.visible = true
	else:
			$labels/flavor_text.text = flavor_text_fail[randi_range(0,9)]
			$labels/score.text = "Score: " + str(GameManager.score)
			$labels/high_score.text = "Best: " + str(GameManager.high_score)
			$labels/new_high_score.visible = false
	
func _on_play_again_pressed() -> void:
	GameManager.score = 0
	GameManager.multiplier = 1.0
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
