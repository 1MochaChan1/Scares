extends KinematicBody2D


var MAX_SPEED  = 150
var ACCEL = 1000
var motion = Vector2.ZERO

func _physics_process(delta):
	var axis = get_input_axis() 
	if axis == Vector2.ZERO:           #When axis == 0 (no input given)
		apply_friction(ACCEL*delta)    #Player comes to a stop
		
	else:                                    #When axis != 0 (input given)
		apply_movement(axis * ACCEL * delta) #Player starts moving
	motion = move_and_slide(motion)

func get_input_axis():
	var axis = Vector2.ZERO
	#Determining the x-axis 
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	#Determining the y-axis
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()

# if motion.length > amount, i.e. if you are stopping the motion
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

# motion is nothing but velocity here.
func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)


