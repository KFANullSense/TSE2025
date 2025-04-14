extends Node

enum GameState {
	MAINMENU,
	PLAYERSELECT,
	LOADING,
	GAMERUNNING,
	GAMEPAUSED
}

var playerDataList = []
var playerObjectList = []
var gameScene = "res://Game Scenes/placeholderLevel.tscn"
var playerScene = preload("res://Game Scenes/Player.tscn")
var localGameState : GameState

var temporaryInputNames = []

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
		
	UpdateGameState(GameState.GAMERUNNING)
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
		
		parentNode.add_child(localPlayer)
		
		playerObjectList.append(localPlayer)
		
	UpdateGameState(GameState.GAMERUNNING)

func UpdateGameState(newState: int):
	if (newState >= 0 and newState < GameState.size()):
		localGameState = newState
	else:
		push_warning("GameManager: Attempting to change to an invalid state.")
		
func CreatePlayerInputMaps():
	var actionList := InputMap.get_actions()
	
	for playerNum in range(playerDataList.size() - 1):
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
