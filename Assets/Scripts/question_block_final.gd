extends Area2D

@export var spawned_ypos_offset = 600
@export var world_scale = 20

enum State { UNTOUCHED, TOUCHED}
var state: int = State.UNTOUCHED
var original_position: Vector2

func _ready():
	original_position = position
	

func _on_body_entered(body):
	if body.is_in_group("Mario") and state == State.UNTOUCHED:
		print("touched")
		bump_block()

func bump_block():
	state = State.TOUCHED
	$Sprite2D.frame = 1  
	
	#Global.spawn_beer_bottle(self.global_position + Vector2(0, -20))
	bump_upwards()
	var coin_scene = load("res://Scenes/coin.tscn")
	var coin = coin_scene.instantiate()
	get_parent().add_child(coin)
	coin.scale.x = world_scale
	coin.scale.y = world_scale
	coin.position.x = position.x
	coin.position.y = position.y - spawned_ypos_offset
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	return_to_original_position()



# Function to move the block upwards
func bump_upwards():
	position.y -= 10  # Move upwards by 10 units

# Function to return the block to its original position
func return_to_original_position():
	position = original_position
