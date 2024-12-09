extends Area2D



func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		area.get_parent().flagpole1_touched()
