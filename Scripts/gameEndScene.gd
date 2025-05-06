extends Node2D

func _ready() -> void:
	get_node("CanvasLayer/Score").text = str(GameManager.currentScore)
	updateStarSprite()

func mainMenu():
	GameManager.ReturnToMainMenu()

func updateStarSprite():
	var currentScore: int = GameManager.currentScore
	var scoreThresholds: Array[int] = GameManager.loadedLevelValues.LEVEL_VALUES[GameManager.currentLevelIndex].starThresholds
	
	var starTexture: Texture2D
	
	if (currentScore >= scoreThresholds[2]):
		starTexture = SpriteLoader.threeStarSprite
	elif (currentScore >= scoreThresholds[1]):
		starTexture = SpriteLoader.twoStarSprite
	elif (currentScore >= scoreThresholds[0]):
		starTexture = SpriteLoader.oneStarSprite
	else:
		starTexture = SpriteLoader.zeroStarSprite
	
	get_node("CanvasLayer/StarSprites").texture = starTexture
	
