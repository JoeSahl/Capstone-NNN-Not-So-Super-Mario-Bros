extends CharacterBody2D

# Might delete crouching mechanic from final product

@export var fireball_scene: PackedScene
var can_throw = true
var is_throwing = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_small = $SmallCollisionShape2D
@onready var collision_shape_large = $Big_FireCollisionShape2D
@onready var fireball_timer = $FireballTimer

const GRAVITY = 1500.0
const AIR_GRAVITY = 3900.0
const WALK_SPEED = 1000.0
const RUN_SPEED = 1300.0
const JUMP_VELOCITY = -2300.0

var state = "small"

var is_big = false
var is_fire = false
var can_grow = true
var can_fire = true

func _ready():
	collision_shape_small.disabled = false
	collision_shape_large.disabled = true
	fireball_timer.connect("timeout", Callable(self, "on_FireballTimer_timeout"))

func _physics_process(delta: float) -> void:
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

	if state == "small":
		_small_movement(delta)
	elif state == "big":
		_big_movement(delta)
	elif state == "fire":
		_fire_movement(delta)

	move_and_slide()

func _small_movement(delta):
	collision_shape_small.disabled = false;
	collision_shape_large.disabled = true;
	
	# Small animations.
	if (velocity.x > 1 || velocity.x < -1):
		animated_sprite_2d.animation = "small_walking"
	else:
		animated_sprite_2d.animation = "small_stationary"

	if not is_on_floor():
		velocity.y += AIR_GRAVITY * delta
		animated_sprite_2d.animation = "small_jump"
	else:
		velocity.y += GRAVITY * delta
	
	move_and_slide()

func _big_movement(delta):
	collision_shape_small.disabled = true;
	collision_shape_large.disabled = false;
	
	# Big animations.
	if (velocity.x > 1 || velocity.x < -1):
		animated_sprite_2d.animation = "big_walking"
	else:
		animated_sprite_2d.animation = "big_stationary"
	
	if not is_on_floor():
		velocity.y += AIR_GRAVITY * delta
		animated_sprite_2d.animation = "big_jump"
	else:
		velocity.y += GRAVITY * delta
	
	# Handles crouching.
	if Input.is_action_pressed("crouch") and is_on_floor():
		animated_sprite_2d.animation = "big_crouch"
		velocity.x = 0;

	move_and_slide()

func _fire_movement(delta):
	collision_shape_small.disabled = true;
	collision_shape_large.disabled = false;
	
	# Fire animations.
	if (velocity.x > 1 || velocity.x < -1):
		animated_sprite_2d.animation = "fire_walking"
	else:
		animated_sprite_2d.animation = "fire_stationary"
	
	if not is_on_floor():
		velocity.y += AIR_GRAVITY * delta
		animated_sprite_2d.animation = "fire_jump"
	else:
		velocity.y += GRAVITY * delta
	
	# Handles crouching.
	if Input.is_action_pressed("crouch") and is_on_floor():
		animated_sprite_2d.animation = "fire_crouch"
		velocity.x = 0;

	if Input.is_action_pressed("attack") and can_throw:
		animated_sprite_2d.animation = "fire_throwing"
		animated_sprite_2d.play()
		throw_fireball()

	move_and_slide()

# Handles growing after collecting a mushroom
func grow():
	if can_grow:
		if not is_big and not is_fire:
			state = "big"
			is_big = true
			can_grow = false
			set_physics_process(false)
			animated_sprite_2d.animation = "grow_&_shrink"
			animated_sprite_2d.play()

# Handles powering up after collecting a fire flower
func flameOn():
	if can_fire:
		if not is_fire:
			set_physics_process(false)
			if state == "small":
				state = "fire"
				is_fire = true
				is_big = true
				can_grow = false
				animated_sprite_2d.animation = "small_power_up"
				animated_sprite_2d.play()
			elif state == "big":
				state = "fire"
				is_fire = true
				is_big = true
				can_grow = false
				animated_sprite_2d.animation = "big_power_up"
				animated_sprite_2d.play()

# Handles fireball behavior
func throw_fireball():
	is_throwing = true
	can_throw = false
	var fireball = fireball_scene.instantiate()
	fireball.position = position + Vector2(394, -281)
	
	if animated_sprite_2d.flip_h:
		fireball.set("velocity", Vector2(1500 * -1, 0))
	else:
		fireball.set("velocity", Vector2(1500 * 1, 0))
	
	get_parent().add_child(fireball)
	animated_sprite_2d.play("fire_throwing")
	fireball_timer.start(0.5)

func _on_fireball_timer_timeout() -> void:
	is_throwing = false
	can_throw = true

# Handles shrinking after taking damage (NEEDS TESTING)
func shrink():
	state = "small"
	is_big = false
	can_grow = true
	set_physics_process(false)
	animated_sprite_2d.animation = "grow_&_shrink"
	animated_sprite_2d.play_backwards()

# Handles powering down after taking damage (NEEDS TESTING)
func weaken():
	state = "big"
	is_fire = false
	can_fire = true
	set_physics_process(false)
	animated_sprite_2d.animation = "big_power_up"
	animated_sprite_2d.play_backwards()

# Handles deaths (NEEDS WORK)
func death():
	animated_sprite_2d.animation = "death"
	animated_sprite_2d.play()

# Handles animation for growing, shrinking, powering up, and attacking (NEEDS WORK)
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "grow_&_shrink":
		if state == "big":
			animated_sprite_2d.animation = "big_stationary"
			animated_sprite_2d.play()
			set_physics_process(true)
		elif state == "small":
			animated_sprite_2d.animation = "small_stationary"
			animated_sprite_2d.play()
			set_physics_process(true)
	elif animated_sprite_2d.animation == "small_power_up" or animated_sprite_2d.animation == "big_power_up":
		if state == "fire":
			animated_sprite_2d.animation = "fire_stationary"
			animated_sprite_2d.play()
			set_physics_process(true)
#	elif animated_sprite_2d.animation == "fire_throwing":
#		if state == "fire":
#			animated_sprite_2d.animation = "fire_stationary"
#			animated_sprite_2d.play()

# Handles animation for reaching the flagpole (NOT DONE)
func poleReached():
	if state == "small":
		animated_sprite_2d.animation = "small_flagpole"
		animated_sprite_2d.play()
	elif state == "big":
		animated_sprite_2d.animation = "big_flagpole"
		animated_sprite_2d.play()