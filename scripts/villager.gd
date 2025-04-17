extends Area2D
#####GLOBAL VARIABLES###########################################################
@export var multiplier_value = .25
################################################################################
func _ready() -> void:
	$AnimatedSprite2D.play("villager_spawn")
	$spawn_timer.start(1)
	
func _on_spawn_timer_timeout() -> void:
	$AnimatedSprite2D.play("villager_idle")

func _on_body_entered(_body: Node2D) -> void:
	$AudioStreamPlayer2D.play()
	$AnimatedSprite2D.play("villager_saved")
	$CollisionShape2D.call_deferred("set_disabled", true)
	$collection_timer.start(.6)
	GameManager.update_mult(multiplier_value)

	
func _on_collection_timer_timeout() -> void:
	queue_free()
