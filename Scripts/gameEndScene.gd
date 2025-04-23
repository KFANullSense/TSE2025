extends Node2D

func _ready() -> void:
	get_node("CanvasLayer/Score").text = str(GameManager.currentScore)

func mainMenu():
	GameManager.ReturnToMainMenu()
