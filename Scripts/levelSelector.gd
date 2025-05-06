extends Label

@onready var rightButton: Button = get_node("%RightButton")
@onready var leftButton: Button = get_node("%LeftButton")
@onready var maxLevels: int = GameManager.gameScenes.size()

func _ready() -> void:
	updateLabelsAndInteractivity()

func changeLevelNum(rightOrLeft: bool):
	var increment: int
	
	if (rightOrLeft):
		increment = 1
	else:
		increment = -1
	
	GameManager.currentLevelIndex = clamp(GameManager.currentLevelIndex + increment, 0, maxLevels - 1)
	updateLabelsAndInteractivity()
	
	
func updateLabelsAndInteractivity():
	var levelNum: int = GameManager.currentLevelIndex + 1
	
	leftButton.disabled = (levelNum == 1)
	rightButton.disabled = (levelNum == maxLevels)
	
	text = "Level " + str(levelNum)
