extends Enemy


func _process(delta):
	
	
	position.x -= delta * horizontal_speed

	if !raycast_down.is_colliding():
		position.y += delta * vertical_speed
	elif not isdead:
		if raycast_left.is_colliding() || !raycast_bl.is_colliding() || !raycast_br.is_colliding():
			horizontal_speed *= -1
			position.x += self.contact_jump
			get_child(0).flip_h = true

		
		if raycast_right.is_colliding():
			horizontal_speed *= -1
			position.x -= self.contact_jump
			get_child(0).flip_h = false;
