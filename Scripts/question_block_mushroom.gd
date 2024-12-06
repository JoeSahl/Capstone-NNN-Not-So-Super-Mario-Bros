extends Area2D

@export var has_item = true

enum State { UNTOUCHED, TOUCHED}
var state: int = State.UNTOUCHED
var original_position: Vector2

func _ready():
	original_position = position

func _on_body_entered(body) -> void:
	if body.is_in_group("Mario") and state == State.UNTOUCHED:
		bump_block()

func bump_block():
	state = State.TOUCHED
	$Sprite2D.frame = 1  
	
	if has_item:
		has_item = false
		spawn_item("res://scenes/mushroom.tscn")
	
	bump_upwards()
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	return_to_original_position()

# Function to spawn item
func spawn_item(scene_path: String):
	var item_scene = load(scene_path)
	var item = item_scene.instantiate()
	item.scale = Vector2(16, 16)
	item.position = position + Vector2(0, -300)
	get_parent().add_child(item)

# Function to move the block upwards
func bump_upwards():
	position.y -= 10  # Move upwards by 10 units

# Function to return the block to its original position
func return_to_original_position():
	position = original_position
