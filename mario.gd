extends CharacterBody2D


const WALK_SPEED = 300.0
const RUN_SPEED = 400.0
const JUMP_VELOCITY = -600.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Animations
	if (velocity.x > 1 || velocity.x < -1):
		animated_sprite_2d.animation = "small_walking"
	else:
		animated_sprite_2d.animation = "small_stationary"
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "small_jump"

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * WALK_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 12)

	animated_sprite_2d.flip_h = velocity.x < 0

	if Input.is_key_pressed(Key.KEY_RIGHT) and Input.is_key_pressed(Key.KEY_SHIFT):
		velocity.x = RUN_SPEED;
	elif Input.is_key_pressed(Key.KEY_LEFT) and Input.is_key_pressed(Key.KEY_SHIFT):
		velocity.x = -RUN_SPEED;
	elif Input.is_key_pressed(Key.KEY_RIGHT):
		velocity.x = WALK_SPEED;
	elif Input.is_key_pressed(Key.KEY_LEFT):
		velocity.x = -WALK_SPEED;
	else:
		velocity.x = 0;

	move_and_slide()
