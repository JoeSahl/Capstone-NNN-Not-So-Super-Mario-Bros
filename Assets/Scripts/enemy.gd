extends Area2D


class_name Enemy

@export var horizontal_speed = 800
@export var vertical_speed = 1500
@export var contact_jump = 40
@export var isdead = false
@export var isInShell = false
@export var isShellMoving = false
@export var can_damage = false

@onready var raycast_down = $RayCastDown as RayCast2D 
@onready var raycast_left = $RayCastLeft as RayCast2D
@onready var raycast_right = $RayCastRight as RayCast2D
@onready var raycast_bl = $RayCastBL as RayCast2D
@onready var raycast_br = $RayCastBR as RayCast2D
@onready var animation = $AnimatedSprite2D as AnimatedSprite2D
@onready var manager = $"../LevelManager"

func _ready() -> void:
	add_to_group("Enemy")

func _process(delta):
	position.x -= delta * horizontal_speed

	if !raycast_down.is_colliding():
		position.y += delta * vertical_speed
	if not isdead:
		if raycast_left.is_colliding() || !raycast_bl.is_colliding() || !raycast_br.is_colliding():
			horizontal_speed *= -1
			position.x += contact_jump
			get_child(0).flip_h = true

		
		if raycast_right.is_colliding() || !raycast_bl.is_colliding() || !raycast_br.is_colliding():
			horizontal_speed *= -1
			position.x -= contact_jump
			get_child(0).flip_h = false;

		
	
		
func die_to_stomp():
	horizontal_speed = 0;
	vertical_speed = 0;
	animation.play("dead")
	isdead = true
	manager = $"../LevelManager"
	manager.score_increased(100)
	await get_tree().create_timer(0.5).timeout
	queue_free()

func get_in_shell():
	animation.play("dead")
	horizontal_speed = 0
	isInShell = true
	isShellMoving = false
	can_damage = false
	manager.score_increased(100)
	
func kick_shell(direction):
	horizontal_speed = 1800*direction
	isShellMoving = true
	can_damage = true

func die_to_fireball():
	die_to_stomp()
