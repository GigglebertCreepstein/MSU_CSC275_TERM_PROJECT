extends Area2D
#####GLOBAL VARIABLES###########################################################
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collection_timer: Timer = $collection_timer
signal villager_saved
################################################################################
func _ready() -> void:
	animated_sprite_2d.play("default")
func _on_body_entered(body: Node2D) -> void:
	remove_child(collision_shape_2d)
	emit_signal("villager_saved")
	animated_sprite_2d.play("collect")
	collection_timer.start(.6)

func _on_collection_timer_timeout() -> void:
	queue_free()
