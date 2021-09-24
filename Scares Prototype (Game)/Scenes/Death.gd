extends Control

var scene_to_load = ""

func _ready():
	$AudioStreamPlayer.play()



func _on_Retry_pressed():
	scene_to_load = "res://Scenes/Main.tscn"
	$FadeIn.show()
	$FadeIn.fade_in()


func _on_Main_Menu_pressed():
	scene_to_load = "res://Game_Files/Assets_UI/Menu Screen/Menu.tscn"
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_in_finished():
	get_tree().change_scene(scene_to_load)


func _on_AnimationPlayer_animation_finished(anim_name):
	$FadeOutBlack.hide()
