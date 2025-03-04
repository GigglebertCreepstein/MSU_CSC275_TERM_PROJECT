extends CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $hitbox/death_timer
@onready var hitbox_collision: CollisionShape2D = $hitbox/hitbox_collision

func _ready() -> void:
	animated_sprite_2d.play("idle")
	move_and_collide(velocity)

func _on_hitbox_area_entered(area: Area2D) -> void:
	animated_sprite_2d.play("death")
	death_timer.start(.4)


func _on_death_timer_timeout() -> void:
	queue_free()
