extends Node2D


func _on_button_pressed():
	GameManager.UpdateGameState(1)
	get_tree().change_scene_to_file("res://Game Scenes/player_select_menu.tscn")
