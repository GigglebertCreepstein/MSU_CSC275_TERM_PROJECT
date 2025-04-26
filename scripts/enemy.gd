extends CharacterBody2D
"""
Slime enemy character with movement, attack, and death behaviors.
Handles animations, collisions, and scoring when defeated.
"""

# Node References
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $hitbox/death_timer
@onready var hitbox_collision: CollisionShape2D = $hitbox/hitbox_collision
@onready var movement_timer: Timer = $movement_timer
@onready var attack_collision: Area2D = $attack_collision
@onready var attack_shape = $attack_collision/attack_shape

# Configuration Variables
@export var enemy_score_value := 100  # Points awarded when defeated
@export var move_speed: float = 50.0  # Base movement speed

# State Variables
var is_dead := false          # Tracks if enemy is in death state
var just_moved := false       # Prevents rapid direction changes
var enemy_spawned := false    # Tracks if spawn animation completed

func _ready() -> void:
	"""Initialize enemy with spawn animation and setup timers."""
	animated_sprite_2d.play("slime_spawn")
	$spawn_timer.start(1)  # Start spawn sequence

func _on_spawn_timer_timeout() -> void:
	"""Complete spawn sequence and begin normal behavior."""
	animated_sprite_2d.play("slime_idle")
	
	# Enable collisions after spawn animation
	if hitbox_collision:
		hitbox_collision.disabled = false
	if attack_shape:
		attack_shape.disabled = false
		
	movement_timer.start(.5)  # Start movement behavior
	enemy_spawned = true     # Mark as fully spawned

func _process(delta: float) -> void:
	"""Handle movement if enemy is active."""
	if enemy_spawned and not is_dead:
		move_and_collide(velocity * delta)

func enemy_death(_area: Area2D) -> void:
	if is_dead: 
		return
	
	is_dead = true
	# ... other death code ...
	
	# Use call_deferred to ensure GameManager is ready
	GameManager.call_deferred("update_score", enemy_score_value)
	
	is_dead = true
	velocity = Vector2.ZERO
	animated_sprite_2d.play("slime_death")
	$AudioStreamPlayer2D.play()
	
	# Disable processing and timers
	movement_timer.stop()
	set_physics_process(false)
	set_process(false)

	# Disconnect spawn timer to prevent duplicate triggers
	if $spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
		$spawn_timer.timeout.disconnect(_on_spawn_timer_timeout)

	# Disable all collision shapes safely
	for path in ["hitbox/hitbox_collision", "wall_collision/wall_collision_shape", "attack_collision/attack_shape"]:
		var node = get_node_or_null(path)
		if node:
			node.set_deferred("disabled", true)

	# Start death sequence and award points
	death_timer.start(1.3)
	GameManager.call_deferred("update_score", enemy_score_value)

func _on_death_timer_timeout() -> void:
	"""Clean up enemy after death animation completes."""
	queue_free()

func _on_movement_timer_timeout() -> void:
	"""Handle random movement pattern."""
	if is_dead: 
		return
		
	if randi_range(0, 1) == 0 and not just_moved:
		# Move in random direction
		velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * move_speed
		just_moved = true
	else:
		# Stay still
		just_moved = false
		velocity = Vector2.ZERO
