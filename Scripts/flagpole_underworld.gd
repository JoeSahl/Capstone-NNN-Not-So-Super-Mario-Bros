extends Area2D

var current_scene: String = "underworld"  # Start with the first scene's name

func _on_body_entered(body):
	if body.is_in_group("Mario"):
		if current_scene == "underworld":
			current_scene = "final_world"
			get_tree().change_scene_to_file("res://scenes/final_world.tscn")
