extends Area2D

var velocity = Vector2(500, 0)
@onready var bounce_strength: float = -900.0
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("Fireball")
	animated_sprite.play("moving")

func _process(delta) -> void:
	self.velocity.y += gravity * delta
	self.position += velocity * delta

func _on_body_entered(body) -> void:
	if body.is_in_group("Enemy"):
		body.queue_free() # replace with body.die()
		animated_sprite.play("exploding")
		queue_free()
	elif body is StaticBody2D or body is CharacterBody2D or body is TileMapLayer:
		velocity.y = bounce_strength
	#	velocity.x = -velocity.x # figure out how to make it change direction upon hitting a wall
