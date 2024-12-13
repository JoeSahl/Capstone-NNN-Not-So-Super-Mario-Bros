extends Enemy

#die() override for koopa
@export var kspeed = 1800
	
func kick_shell(direction):
	horizontal_speed = kspeed*direction

func die_to_fireball():
	if isInShell:
		queue_free()
	else:
		get_in_shell()
