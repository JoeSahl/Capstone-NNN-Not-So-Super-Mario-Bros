extends Area2D

var velocity = Vector2(500, 0)
@onready var bounce_strength: float = -900.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var explosion_timer = $ExplosionTimer

func _ready() -> void:
	add_to_group("Fireball")
	animated_sprite.play("moving")

func _process(delta) -> void:
	self.velocity.y += gravity * delta
	self.position += velocity * delta

func _on_area_entered(area) -> void:
	if area.is_in_group("Enemy"):
		area.die_to_fire()
		self.velocity = Vector2.ZERO
		animated_sprite.play("exploding")
		explosion_timer.start()
	elif area is StaticBody2D or area is CharacterBody2D or area is TileMapLayer:
		velocity.y = bounce_strength

func _on_explosion_timer_timeout() -> void:
	queue_free()
