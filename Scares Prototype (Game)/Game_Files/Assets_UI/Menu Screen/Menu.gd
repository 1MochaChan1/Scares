extends Control


var scene_to_load = ""
# Called when the node enters the scene tree for the first time.

func _ready():
	$VBoxContainer/Start.grab_focus()

func _on_Start_pressed():
	scene_to_load = "res://Scenes/Main.tscn"
	$FadeIn.show()
	$FadeIn.fade_in()


func _on_How_To_Play_pressed():
	scene_to_load = "res://Scenes/HowToPlay.tscn"
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_Quit_pressed():
	get_tree().quit()

func _on_FadeIn_fade_in_finished():
	get_tree().change_scene(scene_to_load)
