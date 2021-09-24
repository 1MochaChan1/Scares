extends "res://Game_Files/Enemy/Scripts/State_Template.gd"


func update(host,delta):
	
	host.walk_sound.set_pitch_scale(1)
	host.animSprite.set_speed_scale(1.0)
	var moving_dir  = sign(host.velocity.x)
	var start_pos = host.path_follow.transform.xform(host.path_follow.points[0])
	
	if host.player_spotted:
		host.screech.play()
		return "Chase"
	
	if host.player and host.levelNav and host.path_follow:
		host.reset_path = host.levelNav.get_simple_path(host.global_position, start_pos, true)
		host.line2d.points = host.reset_path

		if host.reset_path.size() >0 :#&& not host.reset_path.size()==1:
			host.velocity = host.global_position.direction_to(host.reset_path[1]) * host.speed
			if host.global_position.distance_to(host.reset_path[0]) < 1:
				host.reset_path.pop_front()
				
				
		if host.reset_path.size() == 1:
			host.velocity = host.global_position.direction_to(host.reset_path[0]) * host.speed
			if host.global_position.distance_to(host.reset_path[0]) < 1:
				host.reset_path.pop_front()

			
		if moving_dir == -1 and host.facing_right:
			host.scale.x *= moving_dir
			host.facing_right = false
		elif moving_dir == 1 and !host.facing_right:
			host.scale.x *= -moving_dir
			host.facing_right = true
		
		if host.reset_path.size() == 0:
			host.velocity = Vector2.ZERO
			host.animSprite.play("Idle")
			return "Patrol"
	host.move()
