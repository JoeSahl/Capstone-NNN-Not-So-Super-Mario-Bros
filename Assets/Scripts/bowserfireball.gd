extends Area2D

@onready var xvelocity = 0
@onready var yvelocity = 0
@onready var elapsed_time = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += xvelocity*delta
	position.y += yvelocity*delta
	
	elapsed_time += delta
	
	if elapsed_time > 4:
		queue_free()

func set_direction(vec: float):
	yvelocity = vec*70
	xvelocity = -70


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		area.get_parent().death()
