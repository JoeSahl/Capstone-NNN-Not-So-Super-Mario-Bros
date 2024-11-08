extends CharacterBody2D

const GRAVITY = 1500.0
const AIR_GRAVITY = 6000.0
const WALK_SPEED = 1300.0
const RUN_SPEED = 1800.0
const JUMP_VELOCITY = -4200.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_small = $SmallCollisionShape2D
@onready var collision_shape_large = $Big_FireCollisionShape2D
var is_large = true
var is_growing_or_shrinking = false

func _ready():
	collision_shape_small.disabled = false;
	collision_shape_large.disabled = true;

func _physics_process(delta: float) -> void:
	if is_growing_or_shrinking:
		return
	
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
		velocity.y += AIR_GRAVITY * delta
		animated_sprite_2d.animation = "small_jump"
	else:
		velocity.y += GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * WALK_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 12)

	# Flips the sprite based on direction.
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

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
	if is_large and Input.is_action_pressed("crouch"):
		animated_sprite_2d.animation = "big_crouch"
		velocity.x = 0;

	move_and_slide()

# Handles growing after collecting an item
func grow():
	if not is_large and not is_growing_or_shrinking:
		is_large = true;
		is_growing_or_shrinking = true
		collision_shape_small.disabled = true;
		collision_shape_large.disabled = false;
		animated_sprite_2d.animation = "grow_&_shrink"
		animated_sprite_2d.play()

# Handles shrinking after taking damage
func shrink():
	if is_large and not is_growing_or_shrinking:
		is_large = false;
		is_growing_or_shrinking = true
		collision_shape_small.disabled = false;
		collision_shape_large.disabled = true;
		animated_sprite_2d.animation = "grow_&_shrink"
		animated_sprite_2d.play_backwards()

# Handles animation for growing and shrinking (NEEDS WORK)
func _on_AnimatedSprit2D_animation_finished() -> void:
	if animated_sprite_2d.animation == "grow_&_shrink":
		if not is_large:
			animated_sprite_2d.animation = "big_stationary"
			animated_sprite_2d.play()
			is_growing_or_shrinking = false;
		else:
			animated_sprite_2d.animation = "small_stationary"
			animated_sprite_2d.play()
			is_growing_or_shrinking = false;

# Handles animation for reaching the flagpole (NOT DONE)
func poleReached():
	animated_sprite_2d.animation = "small_flagpole"
	animated_sprite_2d.play()
	
