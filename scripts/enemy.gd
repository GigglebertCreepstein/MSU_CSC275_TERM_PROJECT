extends CharacterBody2D
#####GLOBAL VARIABLES#####################################################

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $hitbox/death_timer
@onready var hitbox_collision: CollisionShape2D = $hitbox/hitbox_collision
@onready var movement_timer: Timer = $movement_timer
@onready var attack_collision: Area2D = $attack_collision
@export var enemy_score_value = 100
var just_moved = false
##########################################################################
func _ready() -> void:
	animated_sprite_2d.play("slime_spawn")
	$spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	animated_sprite_2d.play("slime_idle")
	if is_instance_valid(hitbox_collision):
		hitbox_collision.disabled = false
	if is_instance_valid($attack_collision/attack_shape):	
		$attack_collision/attack_shape.disabled = false
	movement_timer.start(.5)


func _process(delta: float) -> void:
	move_and_collide(velocity * delta)
###########################################################################

func enemy_death(_area: Area2D) -> void:
	velocity = Vector2.ZERO
	var hitbox_shape = get_node_or_null("hitbox/hitbox_collision")
	if hitbox_shape:
		hitbox_shape.queue_free()
	var wall_shape = get_node_or_null("wall_collision/wall_collision_shape")
	if wall_shape:
			wall_shape.queue_free()
	var attack_shape = get_node_or_null("attack_collision/attack_shape")
	if attack_shape:
		attack_shape.queue_free()
	animated_sprite_2d.play("slime_death")
	death_timer.start(.7)
	GameManager.update_score(enemy_score_value)

func _on_death_timer_timeout() -> void:
	queue_free()

# updates enemy movement. either moves random direction or stays stationary
func _on_movement_timer_timeout() -> void:
	#TODO: try to reduce unnecesary checks
	if randi_range(0,1) == 0 and just_moved == false:
		velocity = Vector2(randf_range(-50,50),randf_range(-50,50))
		if velocity.length() > 1:
			velocity.normalized()	
		just_moved = true
	else:
		just_moved = false
		velocity = Vector2.ZERO
