extends Area2D

@onready var timer = $Timer

func _on_body_entered(body) -> void:
	if body.state == "small":
		body.get_node("SmallCollisionShape2D").queue_free()
	elif body.state == "big" or body.state == "fire": # NEEDS WORK
		body.get_node("Big_FireCollisionShape2D").queue_free()
	
	timer.start()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
