extends KinematicBody2D

# Player Attributes
export var MAX_SPEED  = 25
export var ACCEL = 500
var motion = Vector2.ZERO
var can_sprint: bool  = true
var timer_started : bool = false

onready var sprint_timer = $Sprint_Timer
onready var cooldown_timer = $Cooldown_Timer

# Lighting
onready var light = $Sprite/Position2D/Light2D
onready var light_position = $Sprite/Position2D


# Collectables and Environment
var notes : Array = []
var notes_collected = 0
var axis = Vector2.ZERO
var bushes = []

# Animations
onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")
onready var sprite = $Sprite
onready var puff = $Puff
onready var puff_player = $PuffPlayer
var facing_right : bool = true

# UI
onready var note_counter_UI = $Camera2D/CanvasLayer/Interface/NoteCounter/Label

# Audio
var sfx = []
var pickup_sound = null

func _ready():
	# Getting the Note scene and connecting its signal to a function.
	if get_tree().has_group("Notes"):
		notes = get_tree().get_nodes_in_group("Notes")
		for note in notes:
			note.connect("note_collected", self, "increment_note")
	
	for _child in self.get_children():
		if "PickupSound" in _child.name:
			sfx.append(_child)
	
	# Getting the bush to hide inside
	if get_tree().has_group("Bush"):
		bushes = get_tree().get_nodes_in_group("Bush")
		for bush in bushes:
			bush.connect("player_entered", self, "player_hidden")
			bush.connect("player_exited", self, "player_revealed")
	
func _physics_process(delta):
	var axis = get_input_axis() 
	if axis == Vector2.ZERO:  
		animState.travel("Idle")       #When axis == 0 (no input given)
		apply_friction(ACCEL*delta)    #Player comes to a stop
		
	else:    
		animTree.set("parameters/Idle/blend_position", axis)
		animTree.set("parameters/Run/blend_position", axis)
		animState.travel("Run")  
		apply_movement(axis * ACCEL * delta) #Player starts moving
		sprinting()
		print(sprint_timer.get_time_left())
#		print("can sprint: ",sprint_timer.get_time_left()," cannot sprint: ",cooldown_timer.get_time_left())

	motion = move_and_slide(motion)
	
func get_input_axis():
	
	#Determining the x-axis 
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	#Determining the y-axis
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	#Switching flash_ligth off
	if Input.is_key_pressed(70):
		light.set_enabled(false)
	#flash_light_pos()
	# Normalizing the movement
	return axis.normalized()

# Adjusting the position of the flashlight to where the player is facing.
func flash_light_pos():
	if axis.x > 0:
		light_position.position.x = 3.368
		light_position.rotation_degrees = 0
		if motion.x > 0 and !facing_right:
			puff.scale.x *= -1
			facing_right = true

	elif axis.x < 0 :
		light_position.position.x = -3.368
		light_position.rotation_degrees = -180
		if motion.x < 0 and facing_right:
			puff.scale.x *= -1
			facing_right = false

	elif  axis.y < 0:
		sprite.set_light_mask(2)
		light_position.position.x = 3.368
		light_position.rotation_degrees = -90

	elif axis.y > 0 :
		sprite.set_light_mask(1)
		light_position.position.x = -3.368
		light_position.rotation_degrees = 90

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

# Sprint Mechanics, not yet implemented
func sprinting():
	if Input.is_action_just_pressed("sprint") and can_sprint:
		MAX_SPEED = 50
		if !timer_started:
			sprint_timer.start()
			timer_started =true
		elif timer_started:
			sprint_timer.set_paused(false)
	elif Input.is_action_just_released("sprint"):
		#cooldown_timer.set_wait_time(sprint_timer.get_wait_time() - sprint_timer.get_time_left())
		if timer_started and sprint_timer.get_time_left()>0:
			sprint_timer.set_paused(true)
		
		MAX_SPEED = 25

# Increments the no. of note collected when player picks one up.
func increment_note():
	notes_collected += 1
	note_counter_UI.set_text(str(notes_collected)+"/7")
	pickup_sound = sfx[randi() % sfx.size()]
	pickup_sound.play()
	# Implementing win condition
	if notes_collected == 7:
		puff_player.play("Victory")
		yield(puff_player, "animation_finished")
		get_tree().change_scene("res://Scenes/Victory.tscn")

# Signals
func _on_Sprint_Timer_timeout():
	MAX_SPEED = 25
	can_sprint = false
	$Puff.show()
	puff_player.play("Puffing")
	cooldown_timer.start()

func _on_Cooldown_Timer_timeout():
	can_sprint = true
	$Puff.hide()
	puff_player.stop()
	timer_started = false

func player_hidden():
	light.set_enabled(false)

func player_revealed():
	light.set_enabled(true)
