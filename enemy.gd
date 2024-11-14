extends Area2D


@export var horizontal_speed = 120
@export var vertical_speed = 300
@export var isdead = false

@onready var raycast_down = $RayCastDown as RayCast2D 
@onready var raycast_left = $RayCastLeft as RayCast2D
@onready var raycast_right = $RayCastRight as RayCast2D
@onready var animation = $AnimatedSprite2D as AnimatedSprite2D
@onready var stomp_death_timer = $StompDeathTimer
@onready var fire_death_timer = $FireDeathTimer

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

func die_to_stomp():
	horizontal_speed = 0;
	vertical_speed = 0;
	animation.play("dead")
	isdead = true
	stomp_death_timer.start()

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
	queue_free() # Removes goomba
