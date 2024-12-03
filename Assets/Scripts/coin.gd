extends Area2D

@onready var manager = $"../LevelManager"


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Mario"):
		manager.coin_collected()
		queue_free()
