extends Node

enum GameState {
	MAINMENU,
	PLAYERSELECT,
	LOADING,
	GAMERUNNING,
	GAMEPAUSED,
	GAMEEND
}

const GAME_LENGTH = 120

var playerDataList = []
var playerObjectList = []
var gameScene = "res://Game Scenes/placeholderLevel.tscn"
var playerScene = preload("res://Prefab Objects/Player/Player.tscn")
var localGameState : GameState

var temporaryInputNames = []

var currentRecipeList = []
var currentGameTimer: SceneTreeTimer = null

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
		StartGame()

func StartGame():
	if (localGameState != GameState.PLAYERSELECT):
		push_warning("GameManager: Attempting to start game from an invalid game state.")
		return
		
	CreatePlayerInputMaps()
	get_tree().change_scene_to_file(gameScene)
	
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
	
	currentGameTimer = get_tree().create_timer(GAME_LENGTH)
	await currentGameTimer.timeout
	currentGameTimer = null
	
	EndGame()
	
func EndGame():
	UpdateGameState(GameState.GAMEEND)
