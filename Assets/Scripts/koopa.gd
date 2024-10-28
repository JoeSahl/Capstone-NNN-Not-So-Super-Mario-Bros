extends Enemy

#die() override for koopa
func die():
	if animation.animation != "dead":
		animation.play("dead")
		horizontal_speed = 100
	else:
		horizontal_speed = 0
		isdead = true
