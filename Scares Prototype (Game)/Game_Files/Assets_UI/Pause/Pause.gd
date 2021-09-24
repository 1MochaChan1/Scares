extends CanvasLayer

func _ready():
	set_visible(false)

func _input(event):
	if get_tree().current_scene.name == "Main":
		if Input.is_action_just_pressed("ui_cancel"):
			set_visible(!get_tree().paused)
			get_tree().paused = !get_tree().paused
		elif Input.is_key_pressed(11):
			get_tree().quit()

func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible
