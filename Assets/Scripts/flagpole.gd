extends Area2D



func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		if get_parent().name == "Level_One":
			area.get_parent().flagpole1_touched()
		elif get_parent().name == "Underworld":
			area.get_parent().flagpole2_touched()
