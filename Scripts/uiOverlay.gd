extends CanvasLayer

@onready var timerLabel: RichTextLabel = get_node("%TimeLabel")

func _process(delta: float) -> void:
	if (GameManager.localGameState == GameManager.GameState.GAMERUNNING and GameManager.currentGameTimer != null):
		timerLabel.text = str(GameManager.currentGameTimer.time_left)
