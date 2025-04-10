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

func _ready() -> void:
	$labels/flavor_text.text = flavor_text_fail[randi_range(0,9)]
	$labels/score.text = "Score: " + str(GameManager.score)
	$labels/high_score.text = "Best: " + str(GameManager.high_score)
	
func _on_play_again_pressed() -> void:
	GameManager.score = 0
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
