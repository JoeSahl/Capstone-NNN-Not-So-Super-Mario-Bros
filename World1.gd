extends Node

func spawn_mushroom(pos):
	var MushroomScene = load("res://mushroom.tscn")
	var mushroom = MushroomScene.instantiate()
	mushroom.mushroom_position = pos
	get_tree().root.add_child(mushroom)
