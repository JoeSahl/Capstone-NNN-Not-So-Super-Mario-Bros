extends CanvasLayer

class_name UI

@onready var scorelabel = $MarginContainer/HBoxContainer/ScoreLabel
@onready var coinlabel = $MarginContainer/HBoxContainer/CoinLabel

@onready var center = $MarginContainer/CenterContainer

func _ready() -> void:
	center.visible = false

func setscore(points: int):
	scorelabel.text = "SCORE: %d" %points
	
func setcoins(coins: int):
	coinlabel.text = "COINS: %d" %coins
	
func display_deathscreen():
	center.visible = true
