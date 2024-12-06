extends Area2D

var current_scene: String = "World1"  # Start with the first scene's name

func _on_body_entered(body):
	if body.is_in_group("mario"):
		if current_scene == "World1":
			get_tree().change_scene_to_file("res://underworld.tscn")
			current_scene = "underworld"  # Update the current scene
		elif current_scene == "underworld":
			get_tree().change_scene_to_file("res://final_world.tscn")
			current_scene = "final_world"  # Update the current scene
