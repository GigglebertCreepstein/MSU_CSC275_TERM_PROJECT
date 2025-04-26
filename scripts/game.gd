extends Node2D
"""
Main game controller handling enemy/villager spawning, round system, and game flow.
Manages difficulty progression and round timing.
"""

# Scene References
@export var enemy_scene: PackedScene = preload("res://scenes/objects/enemy.tscn")
@export var villager_scene: PackedScene = preload("res://scenes/objects/villager.tscn")

# Spawn Configuration
@export var spawn_area: Rect2 = Rect2(96, 128, 672, 256)  # Area where enemies can spawn
@export var villager_spawn_rate: float = 5.0  # Fixed villager spawn interval

# Round System Configuration
@export var initial_round_duration: float = 20.0  # Duration of first round in seconds
@export var round_duration_increase: float = 2.0  # How much longer each round gets
@export var initial_spawn_rate: float = 3.0  # Starting spawn rate (seconds between spawns)
@export var spawn_rate_decrease: float = 0.2  # How much faster spawning gets each round
@export var min_spawn_rate: float = 0.5  # Fastest possible spawn rate
@export var enemies_per_round_increase: int = 3  # How many more enemies spawn each round

# Game State
var current_round: int = 1
var enemies_spawned_this_round: int = 0
var enemies_to_spawn_this_round: int = 5  # Starting number of enemies per round
var current_spawn_rate: float
var round_time_remaining: float
var is_round_active: bool = false

# Timer References
var enemy_timer: Timer
var villager_timer: Timer
var round_timer: Timer

# Game Start Dialogue
var start_text = [
	"“Prepare thyself, Challenger!”",
	"“Thou shalt ne’er defeat me!”",
	"“Dost thine thinkest thineself a hero?"
]

func _ready():
	"""Initialize game start sequence"""
	$HUD/game_start_textbox/GameStart.play()

func _process(_delta: float) -> void:
	"""Update round timer display each frame."""
	if is_round_active and round_timer:
		round_time_remaining = round_timer.time_left
		$HUD.update_round_info(current_round, round_time_remaining, enemies_to_spawn_this_round - enemies_spawned_this_round)

func _on_ready_timer_timeout() -> void:
	"""Start game after initial delay"""
	$AudioStreamPlayer2D.play()
	$player.freeze_player = false
	$HUD/game_start_textbox.visible = false
	
	# Setup villager spawn timer
	villager_timer = Timer.new()
	villager_timer.wait_time = villager_spawn_rate
	villager_timer.autostart = true
	villager_timer.one_shot = false
	villager_timer.timeout.connect(_spawn_villager)
	add_child(villager_timer)
	
	# Initialize round system
	current_spawn_rate = initial_spawn_rate
	round_time_remaining = initial_round_duration
	enemies_to_spawn_this_round = 5 + (current_round - 1) * enemies_per_round_increase
	
	# Start first round
	start_new_round()

func start_new_round():
	"""Begin a new round with updated parameters"""
	is_round_active = true
	enemies_spawned_this_round = 0
	
	# Update HUD with new round info
	$HUD.update_round_info(current_round, round_time_remaining, enemies_to_spawn_this_round - enemies_spawned_this_round)
	
	# Setup enemy spawn timer for this round
	enemy_timer = Timer.new()
	enemy_timer.wait_time = current_spawn_rate
	enemy_timer.autostart = true
	enemy_timer.one_shot = false
	enemy_timer.timeout.connect(_spawn_enemy)
	add_child(enemy_timer)
	
	# Create new round timer
	round_timer = Timer.new()
	round_timer.wait_time = round_time_remaining
	round_timer.one_shot = true
	round_timer.timeout.connect(_on_round_end)
	add_child(round_timer)
	round_timer.start()

func _on_round_end():
	"""Handle round completion and prepare next round"""
	is_round_active = false
	
	# Clean up current round timers
	if enemy_timer:
		enemy_timer.stop()
		enemy_timer.queue_free()
	
	# Increase difficulty for next round
	current_round += 1
	round_time_remaining = initial_round_duration + (current_round - 1) * round_duration_increase
	current_spawn_rate = max(initial_spawn_rate - (current_round - 1) * spawn_rate_decrease, min_spawn_rate)
	enemies_to_spawn_this_round = 5 + (current_round - 1) * enemies_per_round_increase
	
	# Brief pause between rounds, then start next round
	get_tree().create_timer(3.0).timeout.connect(start_new_round)

func _spawn_enemy():
	"""Spawn a new enemy at random position if round is active"""
	if is_round_active and enemy_scene and enemies_spawned_this_round < enemies_to_spawn_this_round:
		var enemy = enemy_scene.instantiate()
		enemy.position = _random_spawn_position()
		add_child(enemy)
		enemies_spawned_this_round += 1
		$HUD.update_round_info(current_round, round_time_remaining, enemies_to_spawn_this_round - enemies_spawned_this_round)

		# Stop spawning if we've reached the round limit
		if enemies_spawned_this_round >= enemies_to_spawn_this_round and enemy_timer:
			enemy_timer.stop()

func _spawn_villager():
	"""Spawn a new villager at random position"""
	if villager_scene:
		var villager = villager_scene.instantiate()
		villager.position = _random_spawn_position()
		add_child(villager)

func _random_spawn_position() -> Vector2:
	"""Generate random position within spawn area"""
	return Vector2(
		randf_range(spawn_area.position.x, spawn_area.end.x),
		randf_range(spawn_area.position.y, spawn_area.end.y)
	)
