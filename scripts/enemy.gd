extends CharacterBody2D

##### GLOBAL VARIABLES #####################################################
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $hitbox/death_timer
@onready var hitbox_collision: CollisionShape2D = $hitbox/hitbox_collision
@onready var movement_timer: Timer = $movement_timer
@onready var attack_collision: Area2D = $attack_collision
@onready var attack_shape = $attack_collision/attack_shape
@export var enemy_score_value = 100
@export var move_speed: float = 50.0
var is_dead = false
var just_moved = false
var enemy_spawned = false
##########################################################################

func _ready() -> void:
	animated_sprite_2d.play("slime_spawn")
	$spawn_timer.start(1)

func _on_spawn_timer_timeout():
	
	animated_sprite_2d.play("slime_idle")
	if hitbox_collision:
		hitbox_collision.disabled = false
	if attack_shape:
		attack_shape.disabled = false
	movement_timer.start(.5)
	enemy_spawned = true

func _process(delta: float) -> void:
	if enemy_spawned:
		move_and_collide(velocity * delta)

###########################################################################

# Handles enemy death sequence
func enemy_death(_area: Area2D) -> void:
	if is_dead: return
	is_dead = true

	velocity = Vector2.ZERO
	animated_sprite_2d.play("slime_death")

	movement_timer.stop()
	set_physics_process(false)
	set_process(false)

	# Disconnect the spawn timer signal to prevent duplicate triggers
	if $spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
		$spawn_timer.timeout.disconnect(_on_spawn_timer_timeout) ### NEW

	for path in ["hitbox/hitbox_collision", "wall_collision/wall_collision_shape", "attack_collision/attack_shape"]:
		var node = get_node_or_null(path)
		if node:
			node.set_deferred("disabled", true)

	death_timer.start(1.3)
	GameManager.update_score(enemy_score_value)


func _on_death_timer_timeout() -> void:
	queue_free()

# Updates enemy movement. Either moves in a random direction or stays stationary
func _on_movement_timer_timeout() -> void:
	if randi_range(0,1) == 0 and just_moved == false:
		# Move in a normalized random direction multiplied by move_speed
		velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * move_speed
		just_moved = true
	else:
		just_moved = false
		velocity = Vector2.ZERO
