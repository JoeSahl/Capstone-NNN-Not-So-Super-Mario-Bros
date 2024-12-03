extends Area2D

var velocity = Vector2(500, 0)
@onready var bounce_strength: float = -900.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var speed = 1

func _ready() -> void:
	add_to_group("Fireball")
	animated_sprite.play("moving")

func _process(delta) -> void:
	self.velocity.y += gravity * delta * speed
	self.position += velocity * delta * speed

func _on_body_entered(body) -> void:
	if body is StaticBody2D or body is CharacterBody2D or body is TileMapLayer:
		velocity.y = bounce_strength
	#	velocity.x = -velocity.x # figure out how to make it change direction upon hitting a wall


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		area.die_to_fireball();
		animated_sprite.play("exploding")
		speed = 0
		await get_tree().create_timer(0.6).timeout
		queue_free()
		
