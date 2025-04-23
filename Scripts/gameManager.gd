extends Node

signal scoreChanged

enum GameState {
	MAINMENU,
	PLAYERSELECT,
	LOADING,
	GAMERUNNING,
	GAMEPAUSED,
	GAMEEND
}

var playerDataList = []
var playerObjectList = []

var gameScenes: Array[String] = ["res://Game Scenes/Level1.tscn"]
var gameEndScene: String = "res://Game Scenes/game_end.tscn"
var mainMenuScene: String = "res://Game Scenes/main_menu.tscn"
var playerScene = preload("res://Prefab Objects/Player/Player.tscn")
var recipeUIScene = preload("res://Prefab Objects/UI/recipeUI.tscn")
var overlayUIScene = preload("res://Prefab Objects/UI/ui_overlay.tscn")

var localGameState : GameState
@onready var loadedLevelValues: LevelValues = LevelValues.new()

var temporaryInputNames = []

var currentRecipeList: Array[Recipe] = []
var currentGameTimer: SceneTreeTimer = null
var currentLevelIndex = 0

var currentGameUI = null

var timeBetweenRecipes: float = 30
var currentScore = 0

func AddPlayerToList(playerToAdd):
	if (playerToAdd is not playerData):
		push_warning("GameManager: Attempting to add a player that is incorrectly typed.")
		return
	
	playerDataList.append(playerToAdd)
	
func CheckIfAllPlayersReady():
	for localPlayer in playerDataList:
		if (not localPlayer.isReady):
			return false
		
	return true

func AttemptStartGame():
	if (CheckIfAllPlayersReady()):
		StartGame(currentLevelIndex)

func StartGame(sceneIndex: int):
	if (localGameState != GameState.PLAYERSELECT):
		push_warning("GameManager: Attempting to start game from an invalid game state.")
		return
		
	ClearGameObjects()
	
	CreatePlayerInputMaps()
	get_tree().change_scene_to_file(gameScenes[sceneIndex])
	currentGameUI = overlayUIScene.instantiate()
	get_tree().root.add_child(currentGameUI)
	
	UpdateGameState(GameState.LOADING)

func SpawnPlayers(spawnPoints, parentNode):
	if (localGameState != GameState.LOADING):
		push_warning("GameManager: Attempting to spawn players after game has already started.")
		return
	
	for i in range (playerDataList.size()):
		var localPlayer = playerScene.instantiate()
		localPlayer.updateDeviceID(playerDataList[i].localDeviceID)
		localPlayer.position = spawnPoints[i].position
		
		localPlayer.get_node("PlayerMesh").mesh.material.albedo_color = playerDataList[i].playerColor
		
		parentNode.add_child(localPlayer)
		
		playerObjectList.append(localPlayer)
		
	StartGameTimer()

func UpdateGameState(newState: int):
	if (newState >= 0 and newState < GameState.size()):
		localGameState = newState
	else:
		push_warning("GameManager: Attempting to change to an invalid state.")
		
func CreatePlayerInputMaps():
	var actionList := InputMap.get_actions()
	
	for playerNum in range(playerDataList.size()):
		for action in range (actionList.size()):
			if (actionList[action].begins_with("ui_")):
				continue
			var localActionName = actionList[action] + str(playerNum)
			InputMap.add_action(localActionName)
			temporaryInputNames.append(localActionName)
			var actionEventList = InputMap.action_get_events(actionList[action])
			for event in range(actionEventList.size()):
				var localEvent = actionEventList[event].duplicate(true)
				localEvent.set_device(playerNum)
				InputMap.action_add_event(localActionName, localEvent)

func ClearTemporaryInputs():
	for tempInput in temporaryInputNames:
		InputMap.action_erase_events(tempInput)
		
func StartGameTimer():
	if (localGameState != GameState.LOADING):
		push_warning("GameManager: Trying to start game timer when game is not ready")
		return
	
	UpdateGameState(GameState.GAMERUNNING)
	
	StartRecipeLoop()
	
	currentGameTimer = get_tree().create_timer(loadedLevelValues.LEVEL_VALUES[currentLevelIndex].timeLength)
	await currentGameTimer.timeout
	currentGameTimer = null
	
	EndGame()
	
func StartRecipeLoop():
	if (localGameState != GameState.GAMERUNNING):
		push_warning("GameManager: Trying to start recipe loop when game is not ready")
	
	while (localGameState == GameState.GAMERUNNING):
		var recipeToAdd: Recipe = loadedLevelValues.LEVEL_VALUES[currentLevelIndex].recipeList.pick_random()
		currentRecipeList.append(recipeToAdd)
		
		var localUIObject = recipeUIScene.instantiate()
		recipeToAdd.initializeUIObject(localUIObject)
		currentGameUI.get_node("%RecipeGrid").add_child(localUIObject)
		
		await get_tree().create_timer(timeBetweenRecipes).timeout
	
func HandInRecipe(itemListToCheck):
	var result = CheckRecipeAgainstList(itemListToCheck)
	
	if (result == true):
		CompleteRecipe()
		
	else:
		FailRecipe()
	
func CheckRecipeAgainstList(itemListToCheck):
	for localRecipe in currentRecipeList:
		if (localRecipe.checkIfRecipeMatch(itemListToCheck)):
			localRecipe.recipeUIObject.free()
			currentRecipeList.erase(localRecipe)
			return true
			
	return false
	
func CompleteRecipe():
	currentScore += 20
	scoreChanged.emit()

func FailRecipe():
	currentScore -= 10
	scoreChanged.emit()
	
func EndGame():
	UpdateGameState(GameState.GAMEEND)
	ClearGameObjects()
	get_tree().change_scene_to_file(gameEndScene)

func ClearGameObjects():
	currentRecipeList = []
	if (currentGameTimer != null):
		currentGameTimer.free()
	if (currentGameUI != null):
		currentGameUI.free()
	
func ClearPlayerData():
	currentScore = 0
	ClearTemporaryInputs()
	playerDataList = []
	playerObjectList = []

func ReturnToMainMenu():
	ClearGameObjects()
	ClearPlayerData()
	UpdateGameState(GameState.MAINMENU)
	get_tree().change_scene_to_file(mainMenuScene)
