extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preload("res://scenes/game.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	print("play button pressed")
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
