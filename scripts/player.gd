extends CharacterBody2D
"""
Player character controller handling movement, attacks, and death.
Manages animations and collision detection.
"""

### NODE REFERENCES ###
@onready var player_sprite: AnimatedSprite2D = $player_sprite
@onready var short_attack_hitbox: CollisionShape2D = $short_attack_Area2D/short_attack_hitbox
@onready var attack_timer: Timer = $short_attack_Area2D/attack_timer

### CONFIGURATION ###
@export var speed = 200  # Base movement speed in pixels/second

### PLAYER STATES ###
enum Direction { 
	LEFT, 
	RIGHT, 
	UP, 
	DOWN, 
	UP_RIGHT, 
	UP_LEFT, 
	DOWN_RIGHT, 
	DOWN_LEFT 
}

### STATE VARIABLES ###
var freeze_player = true    # When true, prevents player movement and attacks
var current_direction = Direction.DOWN  # Tracks which way player is facing
var is_alive = true         # Tracks if player is alive or in death state

func _ready() -> void:
	"""Initialize player state and disable attack hitbox."""
	short_attack_hitbox.disabled = true

func _process(_delta: float) -> void:
	"""Main game loop for player state updates."""
	update_player_state()

func update_player_state():
	"""Central function that manages all player behavior."""
	if !freeze_player and is_alive:
		get_player_direction()
		
		if Input.is_action_just_pressed("attack"):
			player_attack()
		elif Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down") or \
			 Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"): 
			player_walk_animation()
			player_movement()
		else:
			player_idle()

func get_player_direction():
	"""Updates current_direction enum based on input combination."""
	if Input.is_action_pressed("move_up") and Input.is_action_pressed("move_left"):
		current_direction = Direction.UP_LEFT
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right"):
		current_direction = Direction.UP_RIGHT
	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_left"):
		current_direction = Direction.DOWN_LEFT
	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_right"):
		current_direction = Direction.DOWN_RIGHT
	elif Input.is_action_pressed("move_up"):
		current_direction = Direction.UP
	elif Input.is_action_pressed("move_down"):
		current_direction = Direction.DOWN
	elif Input.is_action_pressed("move_left"):
		current_direction = Direction.LEFT
	elif Input.is_action_pressed("move_right"):
		current_direction = Direction.RIGHT

func player_attack():
	"""Handle player attack sequence."""
	match current_direction:
		Direction.UP, Direction.UP_RIGHT, Direction.UP_LEFT:
			player_sprite.play("attack_up")
			short_attack_hitbox.rotation_degrees = 90
			short_attack_hitbox.position = Vector2(0, -28)
		Direction.DOWN, Direction.DOWN_RIGHT, Direction.DOWN_LEFT:
			player_sprite.play("attack_down")
			short_attack_hitbox.rotation_degrees = 90
			short_attack_hitbox.position = Vector2(0, 27)
		Direction.LEFT:
			player_sprite.play("attack_left")
			short_attack_hitbox.rotation = 0
			short_attack_hitbox.position = Vector2(-29, 5)
		Direction.RIGHT:
			player_sprite.play("attack_right")
			short_attack_hitbox.rotation = 0
			short_attack_hitbox.position = Vector2(29, 5)
	
	short_attack_hitbox.disabled = false
	attack_timer.start(0.35)
	$short_attack_Area2D/slice.play()
	freeze_player = true

func _on_attack_timer_timeout() -> void:
	"""Callback when attack cooldown finishes."""
	short_attack_hitbox.disabled = true
	freeze_player = false

func player_movement():
	"""Handle player movement physics."""
	velocity = Vector2.ZERO
	var dir_keys_pressed = 0
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1 * speed
		dir_keys_pressed += 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1 * speed
		dir_keys_pressed += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1 * speed
		dir_keys_pressed += 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1 * speed
		dir_keys_pressed += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	if dir_keys_pressed > 2:
		velocity = Vector2.ZERO
		player_sprite.frame = 0
	
	move_and_slide()

func player_walk_animation():
	"""Play appropriate walk animation based on direction."""
	player_sprite.speed_scale = 1
	
	if Input.is_action_pressed("move_left"):
		if Input.is_action_pressed("move_up"):
			if player_sprite.animation != "move_up":
				player_sprite.play("move_up")
		elif Input.is_action_pressed("move_down"):
			if player_sprite.animation != "move_down":
				player_sprite.play("move_down")
		else:
			if player_sprite.animation != "move_left":
				player_sprite.play("move_left")
	
	if Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("move_up"):
			if player_sprite.animation != "move_up":
				player_sprite.play("move_up")
		elif Input.is_action_pressed("move_down"):
			if player_sprite.animation != "move_down":
				player_sprite.play("move_down")
		else:
			if player_sprite.animation != "move_right":
				player_sprite.play("move_right")
	
	if Input.is_action_pressed("move_up") and player_sprite.animation != "move_up":
		player_sprite.play("move_up")
	if Input.is_action_pressed("move_down") and player_sprite.animation != "move_down":
		player_sprite.play("move_down")

func player_idle():
	"""Set player to idle animation based on last facing direction."""
	var animation_name = ""
	
	match current_direction:  
		Direction.UP:
			animation_name = "move_up"
		Direction.DOWN:
			animation_name = "move_down"
		Direction.LEFT:
			animation_name = "move_left"
		Direction.RIGHT:
			animation_name = "move_right"
	
	if player_sprite.animation != animation_name:
		player_sprite.play(animation_name)
	
	player_sprite.frame = 0

func _on_death_collision_area_entered(_area: Area2D) -> void:
	"""Handle player death sequence."""
	is_alive = false
	$"death_collision/406113DaleonfireDead-8Bit".play()
	
	$death_collision/CollisionShape2D.set_deferred("disabled", true)
	$short_attack_Area2D/short_attack_hitbox.set_deferred("disabled", true)
	
	player_sprite.play("death")
	await player_sprite.animation_finished
	
	GameManager.game_over()
