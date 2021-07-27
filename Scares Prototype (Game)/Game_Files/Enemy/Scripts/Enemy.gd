extends KinematicBody2D

onready var States = {
	"Patrol" : $State/Patrol,
	"Chase" : $State/Chase,
	"Reset" : $State/Reset
}

var velocity = Vector2.ZERO
var path: Array = []
var reset_path: Array = []

var player_spotted = false
var dir = 1
export(int) var speed: int = 60

var levelNav: Navigation2D = null
var player = null
var current_state = null
var path_follow = null

onready var line2d = $Line2D
onready var los = $RayCast2D



func _ready():
	change_state("Patrol")
	
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	
	if tree.has_group("LevelNavigation"):
		levelNav = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]
	if tree.has_group("PathFollow"):
		path_follow = tree.get_nodes_in_group("PathFollow")[0]

func _physics_process(delta):
	line2d.global_position = Vector2.ZERO
	if levelNav and player and path_follow:
		var update_state = current_state.update(self,delta)
	
		if update_state in ["Patrol", "Reset"]:
			yield(get_tree().create_timer(1), "timeout")
			change_state(update_state)
		elif update_state in ["Chase"]:
			change_state(update_state)
			
		los.look_at(player.global_position)
		if levelNav and player and path_follow:
			player_detect()
			generate_path()


func change_state(new_state):
	current_state = States[new_state]

func player_detect():
	var collider = los.get_collider()
	if collider and collider.is_in_group("Player"):
		player_spotted = true
	else:
		player_spotted = false

func generate_path():
	if levelNav != null and player != null and player_spotted:
		path = levelNav.get_simple_path(global_position, player.global_position, false)
		line2d.points = path

func move():
	velocity = move_and_slide(velocity)
