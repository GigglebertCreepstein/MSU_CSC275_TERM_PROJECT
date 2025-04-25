extends CharacterBody2D
##################NODE REFERENCES##########
@onready var player_sprite: AnimatedSprite2D = $player_sprite
@onready var short_attack_hitbox: CollisionShape2D = $short_attack_Area2D/short_attack_hitbox
@onready var attack_timer: Timer = $short_attack_Area2D/attack_timer
##################GLOBAL VARIABLES#########
@export var speed = 200
var freeze_player = true
enum direction { LEFT, RIGHT, UP, DOWN, UP_RIGHT, UP_LEFT, DOWN_RIGHT, DOWN_LEFT}
var current_direction = direction.DOWN
var is_alive = true
###########################################
func _ready() -> void:
	#short_attack_hitbox.disabled = true	
	short_attack_hitbox.disabled = true

func _process(_delta: float) -> void:
	update_player_state()

# checks for player inputs and runs the proper action based on result 
func update_player_state():
	if !freeze_player and is_alive:
		get_player_direction()
		if Input.is_action_just_pressed("attack"):
			player_attack()
		elif Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"): 
			player_walk_animation()
			player_movement()
		else:
			player_idle()
	# if no input is being recieved, sets player animation to face most recent direction	

##################PLAYER STATES################################

# updates the enum current_direction based on player input
func get_player_direction():
	if Input.is_action_pressed("move_up") and Input.is_action_pressed("move_left"):
		current_direction = direction.UP_LEFT
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right"):
		current_direction = direction.UP_RIGHT
	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_left"):
		current_direction = direction.DOWN_LEFT
	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_right"):
		current_direction = direction.DOWN_RIGHT
	elif Input.is_action_pressed("move_up"):
		current_direction = direction.UP
	elif Input.is_action_pressed("move_down"):
		current_direction = direction.DOWN
	elif Input.is_action_pressed("move_left"):
		current_direction = direction.LEFT
	elif Input.is_action_pressed("move_right"):
		current_direction = direction.RIGHT

# runs the player attack action
func player_attack():
	#adjusts attack hitbox based on players current direction faced
	match current_direction:
		direction.UP, direction.UP_RIGHT, direction.UP_LEFT:
			player_sprite.play("attack_up")
			short_attack_hitbox.rotation_degrees = 90
			short_attack_hitbox.position = Vector2(0,-28)
		direction.DOWN, direction.DOWN_RIGHT, direction.DOWN_LEFT:
			player_sprite.play("attack_down")
			short_attack_hitbox.rotation_degrees = 90
			short_attack_hitbox.position = Vector2(0,27)
		direction.LEFT:
			player_sprite.play("attack_left")
			short_attack_hitbox.rotation = 0
			short_attack_hitbox.position = Vector2(-29,5)
		direction.RIGHT:
			player_sprite.play("attack_right")
			short_attack_hitbox.rotation = 0
			short_attack_hitbox.position = Vector2(29,5)
	
	short_attack_hitbox.disabled = false
	attack_timer.start(.35)
	$short_attack_Area2D/slice.play()
	freeze_player = true

func _on_attack_timer_timeout() -> void:
	short_attack_hitbox.disabled = true
	freeze_player = false

# handles player movement    
func player_movement():
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
	if  dir_keys_pressed > 2:
		velocity = Vector2.ZERO
		player_sprite.frame = 0
	move_and_slide()

# sets player walk animation
func player_walk_animation():
	#TODO: This could be rewritten to be less messy
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
	var animation_name = ""
	match current_direction:  
		direction.UP:
			animation_name = "move_up"
		direction.DOWN:
			animation_name = "move_down"
		direction.LEFT:
			animation_name = "move_left"
		direction.RIGHT:
			animation_name = "move_right"
	#only play animation if it is different from current one		
	if player_sprite.animation != animation_name:
		player_sprite.play(animation_name)
	# CHANGED: Set the frame to 0 to stay on the first frame instead of stopping the animation
	player_sprite.frame = 0

func _on_death_collision_area_entered(_area: Area2D) -> void:
		is_alive = false
		$"death_collision/406113DaleonfireDead-8Bit".play()
		$death_collision/CollisionShape2D.set_deferred("disabled","true")
		$short_attack_Area2D/short_attack_hitbox.set_deferred("disabled","true")
		print("player death triggered")
		player_sprite.play("death")
		await player_sprite.animation_finished
		GameManager.game_over()	
