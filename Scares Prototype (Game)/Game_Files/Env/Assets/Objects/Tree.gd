extends StaticBody2D


onready var tree_sprite = $Sprite
onready var tree_shadow = $LightOccluder2D


func _on_Area2D_area_entered(area):
	if area.name == "PlayerDetector":
		tree_sprite.set_light_mask(8)
		tree_shadow.set_light_mask(4)
		tree_shadow.set_occluder_light_mask(4)

func _on_Area2D_area_exited(area):
	if area.name == "PlayerDetector":
		tree_sprite.set_light_mask(4)
		tree_shadow.set_light_mask(1)
		tree_shadow.set_occluder_light_mask(1)
