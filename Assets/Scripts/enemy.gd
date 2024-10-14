extends Area2D


class_name Enemy

@export var horizontal_speed = 20
@export var vertical_speed = 100
@export var isdead = false

@onready var raycast_down = $RayCastDown as RayCast2D 
@onready var raycast_left = $RayCastLeft as RayCast2D
@onready var raycast_right = $RayCastRight as RayCast2D
@onready var animation = $AnimatedSprite2D as AnimatedSprite2D

func _process(delta):
	position.x -= delta * horizontal_speed

	if !raycast_down.is_colliding():
		position.y += delta * vertical_speed

	if raycast_left.is_colliding():
		horizontal_speed = -20
		get_child(0).flip_h = true

		
	if raycast_right.is_colliding():
		horizontal_speed = 20
		get_child(0).flip_h = false;

		
	
		
func die():
	horizontal_speed = 0;
	vertical_speed = 0;
	animation.play("dead")
	isdead = true
