extends KinematicBody2D
# Enemy States
onready var States = {
	"Patrol" : $State/Patrol,
	"Chase" : $State/Chase,
	"Reset" : $State/Reset
}

# Enemy properties and attributes
export(int) var speed: int = 20
export(int) var path_number: = 0
var velocity = Vector2.ZERO
var path: Array = []
var reset_path: Array = []
var dir = 1
var facing_right = true

# Player tracking
var player_spotted = false
var player_hidden_signal = []

# Delays
var timer = null
var delay = 1

# Scene nodes Navigation
var levelNav: Navigation2D = null
var player = null
var current_state = null
var path_follow = null

# Enemy Children
onready var line2d = $Line2D
onready var los = $RayCast2D
onready var animSprite = $AnimatedSprite

# Sound
onready var walk_sound = $AnimatedSprite/Walk_Sound
onready var screech = $AnimatedSprite/Screech
onready var disappointed = $AnimatedSprite/DisappointedScreech


func _ready():
	
	animSprite.set_animation("Run")
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(delay)
	timer.connect("timeout", self, "player_detect_false")
	add_child(timer)
	
	change_state("Reset")
	
# Gets the Entire Tree
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	
# Gets the required nodes.
	if tree.has_group("LevelNavigation"):
	#Navigation Polygon Instance
		levelNav = tree.get_nodes_in_group("LevelNavigation")[0] 
	if tree.has_group("Player"):
	# Player
		player = tree.get_nodes_in_group("Player")[0]
	if tree.has_group("PathFollow"):
	#Line2D or PathFollow2D
		path_follow = tree.get_nodes_in_group("PathFollow")[path_number]
	if tree.has_group("Bush"):
		player_hidden_signal = tree.get_nodes_in_group("Bush")
		for bush in player_hidden_signal:
			bush.connect("player_entered", self, "player_entered_exec")
			bush.connect("player_exited", self, "player_exited_exec")

	
# Main Loop
func _physics_process(delta):
	if velocity.length() > 0:
		walk_sound.set_volume_db(0)
	else:
		walk_sound.set_volume_db(-100)
	
	line2d.global_position = Vector2.ZERO
	if levelNav and player and path_follow:
		var update_state = current_state.update(self,delta) 
# Here current state = the node assigned to it
# which could be one of the states.
# Hence we can access the outside code.
	
		if update_state in ["Patrol", "Reset"]:
			walk_sound.set_pitch_scale(1)
			yield(get_tree().create_timer(2), "timeout")
			walk_sound.set_volume_db(-20)
			animSprite.set_animation("Run")
			change_state(update_state)
		elif update_state in ["Chase"]:
			walk_sound.set_volume_db(2)
			change_state(update_state)
		
# Makes the raycast point towards the player.
		los.look_at(player.global_position)
		if levelNav and player and path_follow:
			player_detect()
			generate_path()
# Function to change the state of the enemy.
func change_state(new_state):
	current_state = States[new_state]


# Returns true if Player is detected.
func player_detect():
	var collider = los.get_collider()
	if collider and (collider.name in ["Player", "PlayerDetector"] or collider.is_in_group("Player")):
		player_spotted = true
		
# Timer keeps starting even if one shot is true so I started it here.
		timer.start() 


# Sets the player_spotted variable to false after delay 
func player_detect_false():
	player_spotted = false
	

# Generates path to the detected player.
func generate_path():
	if levelNav != null and player != null and player_spotted:
		path = levelNav.get_simple_path(global_position, player.global_position, true)
		line2d.points = path

# Setting the ray cast collision layer to NOT DETECT PLAYER
func player_entered_exec():
	los.set_collision_mask(0)
# Setting the ray cast collision layer to DETECT PLAYER
func player_exited_exec():
	los.set_collision_mask(2)

# Enables the enemy to move.
func move():
	velocity = move_and_slide(velocity)

func _on_Player_Detector_area_entered(area):
	if area.name in ["Player", "PlayerDetector"]:
		get_tree().change_scene("res://Scenes/Death.tscn")
