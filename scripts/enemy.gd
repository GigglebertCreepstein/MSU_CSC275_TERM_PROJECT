extends CharacterBody2D
signal increase_score(score_val)
#####GLOBAL VARIABLES#####################################################
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $hitbox/death_timer
@onready var hitbox_collision: CollisionShape2D = $hitbox/hitbox_collision
@onready var movement_timer: Timer = $movement_timer
@onready var attack_collision: Area2D = $attack_collision
@onready var enemy_score_value = 100
var just_moved = false
##########################################################################
func _ready() -> void:
	animated_sprite_2d.play("idle")
	movement_timer.start(.5)

func _process(delta: float) -> void:
	move_and_collide(velocity * delta)
###########################################################################

func enemy_death(area: Area2D) -> void:
	velocity = Vector2.ZERO
	attack_collision.remove_child($attack_collision/attack_shape)
	animated_sprite_2d.play("death")
	death_timer.start(.4)
	increase_score.emit(enemy_score_value)

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

func _on_attack_collision_area_entered(area: Area2D) -> void:
	print("attack collision triggered")
