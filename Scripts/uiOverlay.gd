extends CanvasLayer

@onready var timerLabel: RichTextLabel = get_node("%TimeLabel")
@onready var scoreLabel: RichTextLabel = get_node("%CoinLabel")

func _ready() -> void:
	updateScore()
	GameManager.scoreChanged.connect(updateScore)

func _process(delta: float) -> void:
	if (GameManager.localGameState == GameManager.GameState.GAMERUNNING and GameManager.currentGameTimer != null):
		timerLabel.text = str(roundi(GameManager.currentGameTimer.time_left))

func updateScore():
	scoreLabel.text = str(roundi(GameManager.currentScore))
