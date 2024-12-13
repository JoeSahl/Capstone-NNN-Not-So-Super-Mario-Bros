extends Node2D

@onready var gamemanager = $LevelManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0,0,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func victory():
	var level3_scene = load("res://Scenes/final_world.tscn")
	if level3_scene:
		var level3 = level3_scene.instantiate()
		get_parent().add_child(level3)
		level3.global_position = global_position
		get_tree().current_scene = level3
		level3.get_child(5).carry_points(gamemanager.points, gamemanager.coins)
		queue_free()
	else:
		print("failed to load level 2")
