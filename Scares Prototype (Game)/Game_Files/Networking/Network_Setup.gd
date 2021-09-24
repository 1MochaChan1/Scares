extends Control

# This is for the GUI
onready var multiplayer_config_ui = $Multiplayer_Configure
onready var server_ip = $Multiplayer_Configure/Server_IP_Address

onready var device_ip = $CanvasLayer/Device_IP_Address

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server",self,"_connected_to_server")
	
	device_ip.text = Network.ip_address #Network here is Network.gd
	
func _player_connected(id) -> void:
	print("Player " + str(id) + " connected")

func _player_disconnected(id) -> void:
	print("Player " + str(id) + " disconnected")

func _on_Create_Server_pressed():
	multiplayer_config_ui.hide()
	Network.create_server()


func _on_Join_Server_pressed():
	if server_ip.text != "":
		multiplayer_config_ui.hide()
		Network.ip_address = server_ip.text
		Network.join_server()
