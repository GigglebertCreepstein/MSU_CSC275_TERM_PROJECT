extends Node2D

@export var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
@export var villager_scene: PackedScene = preload("res://scenes/villager.tscn")
@export var spawn_area: Rect2 = Rect2(96, 128, 672, 256) #adjust spawn area of mobs
@export var spawn_aggresion = .2
var base_spawn_rate: float = 3.0 # Base enemy spawn rate
var current_spawn_rate: float = base_spawn_rate 
@export var villager_spawn_rate: float = 5.0  # Fixed 5-second interval for villagers
var enemy_timer: Timer
var villager_timer: Timer

func _ready():
	# Enemy spawn timer
	enemy_timer = Timer.new()
	enemy_timer.wait_time = current_spawn_rate
	enemy_timer.autostart = true
	enemy_timer.one_shot = false
	enemy_timer.timeout.connect(_spawn_enemy)
	add_child(enemy_timer)
	
	# Villager spawn timer
	villager_timer = Timer.new()
	villager_timer.wait_time = villager_spawn_rate
	villager_timer.autostart = true
	villager_timer.one_shot = false
	villager_timer.timeout.connect(_spawn_villager)
	add_child(villager_timer)
	
	GameManager.update_mult_HUD.connect(_update_hud)

func _spawn_enemy():
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.position = _random_spawn_position()
		add_child(enemy)

func _spawn_villager():
	if villager_scene:
		var villager = villager_scene.instantiate()
		villager.position = _random_spawn_position()
		add_child(villager)

func _random_spawn_position() -> Vector2:
	return Vector2(
		randf_range(spawn_area.position.x, spawn_area.end.x),
		randf_range(spawn_area.position.y, spawn_area.end.y)
	)

func _update_hud(multiplier: float):
	# Only adjust enemy spawn rate
	current_spawn_rate = base_spawn_rate / (1.0 + multiplier * spawn_aggresion)
	# 0.2: A tuning factor controlling how aggressively the spawn rate speeds up. (Higher values = spawn rate decreases faster.)
	enemy_timer.wait_time = current_spawn_rate
	enemy_timer.start()
