extends Enemy

#die() override for koopa

	
func kick_shell(direction):
	horizontal_speed = 1800*direction

func die_to_fireball():
	if isInShell:
		queue_free()
	else:
		get_in_shell()
