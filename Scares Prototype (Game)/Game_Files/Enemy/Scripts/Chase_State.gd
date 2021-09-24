extends "res://Game_Files/Enemy/Scripts/State_Template.gd"

func update(host, delta):
	
	host.walk_sound.set_pitch_scale(2.5)
	host.animSprite.set_speed_scale(1.5)
#	var dir = sign(host.player.global_position.x - host.global_position.x)
	var dir =  sign(host.velocity.x)

	if dir == 1 and !host.facing_right:
		host.scale.x *= -1
		host.facing_right = true
			
	elif dir == -1 and host.facing_right:
		host.scale.x *= -1
		host.facing_right = false


	if host.player and host.levelNav and host.path.size()>0:
		if host.path.size()>0 :
			if host.path.size() == 1:
				host.velocity = host.global_position.direction_to(host.path[0]) * host.speed * 1.8
			elif host.path.size()>1:
				host.velocity = host.global_position.direction_to(host.path[1]) * host.speed * 1.8
			if host.global_position.distance_to(host.path[0]) <1:
				host.path.pop_front()
		
		if host.path.size()>0 and !host.player_spotted:
			host.velocity = host.global_position.direction_to(host.path[0]) * host.speed
			if host.global_position.distance_to(host.path[0]) < 1:
				host.path.pop_front()
				
		if host.path.size() == 0:
			host.disappointed.play()
			host.velocity = Vector2.ZERO
			host.animSprite.set_animation("Idle")
			
			return "Reset"
	host.move()
