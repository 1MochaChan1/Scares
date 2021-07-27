extends "res://Game_Files/Enemy/Scripts/State_Template.gd"


func update(host,delta):
	if host.player and host.levelNav and host.path_follow:
		host.reset_path = host.levelNav.get_simple_path(host.global_position, host.path_follow.global_position, false)
		host.line2d.points = host.reset_path
		
		if host.player_spotted:
			return "Chase"


		if host.reset_path.size() >0 :#&& not host.reset_path.size()==1:
			host.velocity = host.global_position.direction_to(host.reset_path[1]) * host.speed
			if host.global_position.distance_to(host.reset_path[0]) < 1:
				host.reset_path.pop_front()
				
				
		if host.reset_path.size() == 1:
			host.velocity = host.global_position.direction_to(host.reset_path[0]) * host.speed
			if host.global_position.distance_to(host.reset_path[0]) < 1:
				host.reset_path.pop_front()
		
		if host.reset_path.size() == 0:
			host.velocity = Vector2.ZERO
			return "Patrol"
	host.move()
