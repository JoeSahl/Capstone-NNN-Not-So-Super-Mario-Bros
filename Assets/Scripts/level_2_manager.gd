extends Node

class_name Level2Manager

var points = 0
var coins = 0
@onready var ui = $"../UI"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func carry_points(score: int, coins: int):
	ui.setscore(score)
	ui.setcoins(coins)
	points = score
	self.coins = coins

func coin_collected():
	coins += 1
	ui.setcoins(coins)
	
func score_increased(score: int):
	points += score
	ui.setscore(points)
