extends Node

class_name LevelManager

var points = 0
var coins = 0
@onready var ui = $"../UI"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func coin_collected():
	coins += 1
	ui.setcoins(coins)
	
func score_increased(score: int):
	points += score
	ui.setscore(points)
