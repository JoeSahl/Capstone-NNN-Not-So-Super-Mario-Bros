extends CanvasLayer

class_name UI

@onready var scorelabel = $MarginContainer/HBoxContainer/ScoreLabel
@onready var coinlabel = $MarginContainer/HBoxContainer/CoinLabel

@onready var lose = $MarginContainer/YouLoseContainer
@onready var win = $MarginContainer/YouWinContainer

func _ready() -> void:
	lose.visible = false
	win.visible = false

func setscore(points: int):
	scorelabel.text = "SCORE: %d" %points
	
func setcoins(coins: int):
	coinlabel.text = "COINS: %d" %coins
	
func display_deathscreen():
	lose.visible = true

func display_winscreen():
	win.visible = true
