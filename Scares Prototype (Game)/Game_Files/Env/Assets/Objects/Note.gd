extends Node2D

signal note_collected


func _on_Area2D_area_entered(area):
	if area.name in ["Player", "PlayerDetector"]:
		emit_signal("note_collected")
		queue_free()
		
