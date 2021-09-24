extends "res://Game_Files/Enemy/Scripts/State_Template.gd"
#host.dir is where we're headed.

enum {
	FORWARD,
	BACKWARD
}

var point = 0
var state = null


func update(host, delta):
	host.walk_sound.set_pitch_scale(1)
	host.animSprite.set_speed_scale(1.0)
	var path_follow = host.path_follow
	var path = []

# Converting Line 2D's local vectors to global
	for i in range (0, (len(host.path_follow.points)) ):
		path.append(path_follow.transform.xform(path_follow.points[i]))
	
# Checking direction and points to flip the enemy using States
	var moving_dir = sign(host.velocity.x)
	match state:
		FORWARD:
			if point < path.size():
				host.velocity = host.global_position.direction_to(path[point]) * host.speed*25 * delta
				if host.global_position.distance_to(path[point]) <=1.5 :
					point +=  1
		BACKWARD:
			if !(point <= 0):
				host.velocity = host.global_position.direction_to(path[point-1]) * host.speed*25 * delta
				if host.global_position.distance_to(path[point-1]) <=1.5 :
					point -=  1

# Changing states logic
	if point == path.size():
		host.velocity = Vector2.ZERO
		state = BACKWARD
	if point<=0 && !host.player_spotted:
		state = FORWARD

# Flipping enemy logic
	if moving_dir == -1 and host.facing_right:
		host.scale.x *= moving_dir
		host.facing_right = false
	elif moving_dir == 1 and !host.facing_right:
		host.scale.x *= -moving_dir
		host.facing_right = true

	if host.player_spotted:
		point = 0
		host.screech.play()
		return "Chase"
	host.move()
