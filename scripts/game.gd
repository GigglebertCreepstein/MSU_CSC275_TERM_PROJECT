extends Node2D
var enemy = preload("res://scenes/enemy.tscn")

@onready var score_label: Label = $Control/score_label

func _process(delta: float) -> void:
	# !!!!TESTING FEATURE!!!! - left click to spawn in basic enemy at mouse coordinates
	if Input.is_action_just_pressed("left click"):
		var instance = enemy.instantiate()
		add_child(instance)
		instance.position = get_global_mouse_position()
