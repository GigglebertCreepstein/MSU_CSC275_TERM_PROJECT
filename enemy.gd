extends CharacterBody2D
#####GLOBAL VARIABLES#####################################################
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $hitbox/death_timer
@onready var hitbox_collision: CollisionShape2D = $hitbox/hitbox_collision
@onready var movement_timer: Timer = $movement_timer
var just_moved = false
##########################################################################
func _ready() -> void:
	animated_sprite_2d.play("idle")
	movement_timer.start(.5)

func _process(delta: float) -> void:
	move_and_slide()
###########################################################################

func enemy_death(area: Area2D) -> void:
	animated_sprite_2d.play("death")
	death_timer.start(.4)

func _on_death_timer_timeout() -> void:
	queue_free()

# updates enemy movement. either moves random direction or stays stationary
func _on_movement_timer_timeout() -> void:
	if randi_range(0,1) == 0 and just_moved == false:
		velocity = Vector2(randf_range(-50,50),randf_range(-50,50))
		if velocity.length() > 1:
			velocity.normalized()	
		just_moved = true
	else:
		just_moved = false
		velocity = Vector2.ZERO
