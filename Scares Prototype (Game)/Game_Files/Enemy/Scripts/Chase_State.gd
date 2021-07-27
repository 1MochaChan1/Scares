extends "res://Game_Files/Enemy/Scripts/State_Template.gd"

func update(host, delta):
	if host.player and host.levelNav and host.path.size()>0:
		if host.path.size()>0 :
			if host.path.size() == 1:
				host.velocity = host.global_position.direction_to(host.path[0]) * host.speed
			elif host.path.size()>1:
				host.velocity = host.global_position.direction_to(host.path[1]) * host.speed
			if host.global_position.distance_to(host.path[0]) <1:
				host.path.pop_front()
		
		if host.path.size()>0 and not host.player_spotted:
			host.velocity = host.global_position.direction_to(host.path[0]) * host.speed
			if host.global_position.distance_to(host.path[0]) < 1:
				host.path.pop_front()
				
		if host.path.size() == 0:
			host.velocity = Vector2.ZERO
			return "Reset"
	host.move()
