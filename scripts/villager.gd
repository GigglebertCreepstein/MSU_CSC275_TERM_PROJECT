extends Area2D
#####GLOBAL VARIABLES###########################################################
@export var multiplier_value = .25
var villager_type = -1
################################################################################
func _ready() -> void:
	villager_type = randi_range(0,1)
	if villager_type == 0:
		$AnimatedSprite2D.play("villager_spawn")
	else:
		$AnimatedSprite2D.play("villager_spawn_2")	
	$spawn_timer.start(1)
	
func _on_spawn_timer_timeout() -> void:
	if villager_type == 0:
		$AnimatedSprite2D.play("villager_idle")
	else:
		$AnimatedSprite2D.play("villager_idle_2")	
	
func _on_body_entered(_body: Node2D) -> void:
	$AudioStreamPlayer2D.play()
	if villager_type == 0:
		$AnimatedSprite2D.play("villager_saved")
	else:
		$AnimatedSprite2D.play("villager_saved_2")	
	$CollisionShape2D.call_deferred("set_disabled", true)
	$collection_timer.start(.6)
	GameManager.update_mult(multiplier_value)

	
func _on_collection_timer_timeout() -> void:
	queue_free()
