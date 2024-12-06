extends Area2D

var current_scene: String = "level_one"  # Start with the first scene's name

func _on_body_entered(body):
	if body.is_in_group("Mario"):
		if current_scene == "level_one":
			current_scene = "underworld"
			get_tree().change_scene_to_file("res://scenes/underworld.tscn")
