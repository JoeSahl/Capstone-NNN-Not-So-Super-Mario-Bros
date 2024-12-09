extends Area2D

@export var bowserfireballscene = preload("res://Scenes/bowserfireball.tscn")

@onready var speed = 800
@onready var bowser_gravity = 1000
@onready var bowserdownraycast = $RayCast2D
@onready var elapsed_time = 0
@onready var direction = 1
@onready var animation = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if !bowserdownraycast.is_colliding():
		position.y += delta*bowser_gravity
		
	elapsed_time += delta
	
	if elapsed_time > 3:
		direction *= -1
		elapsed_time = 0
		shoot_fire()
		
	if direction == 1:
		animation.flip_h = false
	else:
		animation.flip_h = true
		
		
	position.x += direction * speed * delta

	


func shoot_fire():
	var bowserfire = bowserfireballscene.instantiate()
	bowserfire.position.x = self.position.x
	bowserfire.position.y = self.position.y
