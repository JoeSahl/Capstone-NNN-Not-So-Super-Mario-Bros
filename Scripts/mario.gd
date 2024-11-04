extends CharacterBody2D

const WALK_SPEED = 400.0
const RUN_SPEED = 500.0
const JUMP_VELOCITY = -600.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_small = $SmallCollisionShape2D
@onready var collision_shape_large = $Big_FireCollisionShape2D
var is_large = false;

func _physics_process(delta: float) -> void:
	# Animations
	if (velocity.x > 1 || velocity.x < -1):
		animated_sprite_2d.animation = "small_walking"
	elif (velocity.x > 1 || velocity.x < -1) and is_large:
		animated_sprite_2d.animation = "big_walking"
	elif (velocity.x == 0):
		animated_sprite_2d.animation = "small_stationary"
	elif (velocity.x == 0) and is_large:
		animated_sprite_2d.animation = "big_stationary"
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "small_jump"

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * WALK_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 12)

	# Flips the sprite based on direction.
	animated_sprite_2d.flip_h = velocity.x < 0

	# Handles running.
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

	# Handles crouching.
	if is_large and Input.is_action_pressed("ui_down"):
		animated_sprite_2d.animation = "big_crouch"
		velocity.x = 0;

	move_and_slide()

# Handles growing after collecting an item (NOT DONE YET)
func grow():
	if not is_large:
		is_large = true;
		collision_shape_small.disabled = true;
		collision_shape_large.disabled = false;
		animated_sprite_2d.animation = "grow_&_shrink"
		animated_sprite_2d.animation = "big_stationary"

# Handles shrinking after taking damage (NOT DONE YET)
func shrink():
	if is_large:
		is_large = false;
		collision_shape_small.disabled = false;
		collision_shape_large.disabled = true;
		animated_sprite_2d.animation = "grow_&_shrink"
		animated_sprite_2d.animation = "small_stationary"
