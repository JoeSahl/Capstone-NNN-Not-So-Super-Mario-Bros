extends Area2D


enum State { UNTOUCHED, TOUCHED}
var state: int = State.UNTOUCHED
var original_position: Vector2

func _ready():
	original_position = position
	

func _on_body_entered(body):
	if body.is_in_group("mario") and state == State.UNTOUCHED:
		bump_block()

func bump_block():
	state = State.TOUCHED
	$Sprite2D.frame = 1  
	
	#Global.spawn_beer_bottle(self.global_position + Vector2(0, -20))
	bump_upwards()
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	return_to_original_position()



# Function to move the block upwards
func bump_upwards():
	position.y -= 10  # Move upwards by 10 units

# Function to return the block to its original position
func return_to_original_position():
	position = original_position
