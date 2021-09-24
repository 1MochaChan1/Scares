extends Area2D

signal player_entered
signal player_exited

onready var animPlayer = $AnimationPlayer

func _on_Bush_body_entered(body):
	if body.name in ["Player"]:
		emit_signal("player_entered")
		animPlayer.play("Interacted")


func _on_Bush_body_exited(body):
	if body.name in ["Player", "Player Detector"]:
		emit_signal("player_exited")
		animPlayer.play("Interacted")
