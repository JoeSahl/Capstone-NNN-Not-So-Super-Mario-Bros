extends Area2D

var velocity = Vector2(500, 0)
#@onready var bounce_strength: float = -900.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var explosion_timer = $ExplosionTimer
@onready var raycast = $RayCast2D

func _ready() -> void:
	add_to_group("Fireball")
	animated_sprite.play("moving")

func _process(delta) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	
	if raycast.is_colliding() and velocity.y > 0:
		velocity.y = -abs(velocity.y)

func _on_area_entered(area) -> void:
#	if area.collision_layer == 1:
#		print("tile hit")
#		if velocity.y > 0:
#			velocity.y = -abs(velocity.y)
	if area.is_in_group("Enemy"):
		area.die_to_fire()
		velocity = Vector2.ZERO
		animated_sprite.play("exploding")
		explosion_timer.start()

func _on_explosion_timer_timeout() -> void:
	queue_free()
