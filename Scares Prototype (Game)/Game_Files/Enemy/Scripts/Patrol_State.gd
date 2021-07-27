extends "res://Game_Files/Enemy/Scripts/State_Template.gd"

func update(host, delta):
	if host.player_spotted:
		return "Chase"
	if not host.player_spotted and host.path_follow:
		if host.dir == 1:
			if host.path_follow.unit_offset == 1:
				yield(get_tree().create_timer(1), "timeout")
				host.dir = 0
			else:
				#continues towards the end
				host.path_follow.offset += host.speed * delta
		
		elif host.dir == 0:
			if host.path_follow.unit_offset == 0:
				yield(get_tree().create_timer(1), "timeout")
				host.dir = 1
			else:
				host.path_follow.offset -= host.speed *delta
