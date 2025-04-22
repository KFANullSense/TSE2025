extends Node2D


func _start_button_press():
	GameManager.UpdateGameState(1)
	get_tree().change_scene_to_file("res://Game Scenes/player_select_menu.tscn")

func _quit_button_press():
	get_tree().quit()
