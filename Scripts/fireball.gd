extends Area2D

var velocity = Vector2(500, 0)
@onready var animated_sprite = $AnimatedSprite2D
@onready var explosion_timer = $ExplosionTimer
@onready var timer = $Timer
@onready var floor_raycast = $RayCast2D

func _ready() -> void:
	add_to_group("Fireball")
	animated_sprite.play("moving")
	timer.start()

func _process(delta) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	
	if floor_raycast.is_colliding():
		velocity.y = -abs(velocity.y)

func _on_area_entered(area) -> void:
	if area.is_in_group("Enemy"):
		area.die_to_fire()
		velocity = Vector2.ZERO
		animated_sprite.play("exploding")
		explosion_timer.start()

func _on_explosion_timer_timeout() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
