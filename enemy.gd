extends Area2D


@export var horizontal_speed = 120
@export var vertical_speed = 300
@export var isdead = false
@export var isInShell = false
@export var isShellMoving = false

@onready var raycast_down = $RayCastDown as RayCast2D 
@onready var raycast_left = $RayCastLeft as RayCast2D
@onready var raycast_right = $RayCastRight as RayCast2D
@onready var animation = $AnimatedSprite2D as AnimatedSprite2D
@onready var normal_collision_shape = $NormalCollisionShape2D
@onready var shell_collision_shape = $ShellCollisionShape2D
@onready var stomp_death_timer = $StompDeathTimer
@onready var fire_death_timer = $FireDeathTimer
@onready var grace_period_timer = $GracePeriodTimer

var can_damage = false

func _process(delta):
	position.x -= delta * horizontal_speed

	if not raycast_down.is_colliding():
		position.y += delta * vertical_speed

	if raycast_left.is_colliding():
		horizontal_speed = -120
		get_child(0).flip_h = true
	elif raycast_right.is_colliding():
		horizontal_speed = 120
		get_child(0).flip_h = false;

func die_to_stomp(): # Goomba exclusive
	horizontal_speed = 0;
	vertical_speed = 0;
	animation.play("dead")
	isdead = true
	stomp_death_timer.start()

func get_in_shell(): # Koopa exclusive
	if not isInShell: 
		horizontal_speed = 0;
		vertical_speed = 0;
		animation.play("shell")
		isInShell = true
		shell_collision_shape.disabled = false
		normal_collision_shape.disabled = true
		can_damage = false
	else:
		if isShellMoving:
			horizontal_speed = 0
			isShellMoving = false
			can_damage = false

func kick_shell(direction):
	if isInShell and not isShellMoving:
		isShellMoving = true
		can_damage = false
		grace_period_timer.start()
		horizontal_speed = 900 * direction

func _on_area_entered(area) -> void:
	if isShellMoving:
		if area.is_in_group("Enemy"):
			area.die_to_fire()
	else:
		pass

func die_to_fire():
	horizontal_speed = 0;
	vertical_speed = 700;
	rotation_degrees = 180
	isdead = true
	fire_death_timer.start()
	raycast_down.enabled = false
	raycast_left.enabled = false
	raycast_right.enabled = false

func _on_stomp_death_timer_timeout() -> void:
	queue_free() # Removes goomba

func _on_fire_death_timer_timeout() -> void:
	queue_free() # Removes goomba and koopa

# Makes it so the initial shell kick does not damage Mario
func _on_grace_period_timer_timeout() -> void:
	can_damage = true
