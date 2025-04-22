extends Node3D

func _ready() -> void:
	GameManager.SpawnPlayers(get_node("%SpawnPoints").get_children(), self)
