extends Area2D

@export var bowserfireballscene = preload("res://Scenes/bowserfireball.tscn")

@onready var bowser_velocity = 10
@onready var bowserdownraycast = $RayCast2D
@onready var elapsed_time = 0
@onready var direction = 1
@onready var animation = $AnimatedSprite2D
@onready var fall = false
@onready var Mario = $"../Mario"
@onready var fireball_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("default")
	position.y = -84.5
	animation.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	fireball_timer += delta
	
	if fireball_timer > 1.2:
		shoot_fire()
		fireball_timer = 0
	
	if !fall:
		elapsed_time += delta
	
	position.y -= delta*bowser_velocity
	
	if fall:
		if position.y > -84.5:
			fall = false
			position.y = -84.5
			bowser_velocity = 0
			return
		else:
			bowser_velocity -= .7
	else:
		if elapsed_time >= 3:
			bowser_velocity = 60
			elapsed_time = 0
			fall = true

func shoot_fire():
	var bowserfirescene = load("res://Scenes/bowserfireball.tscn")
	if bowserfirescene:
		var bowserfireball = bowserfirescene.instantiate()
		get_parent().add_child(bowserfireball)
		bowserfireball.global_position = global_position
		var vec = (position.y - Mario.position.y)/(position.x - Mario.position.x)
		bowserfireball.set_direction(-vec)
		
		
	


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		area.get_parent().death()
