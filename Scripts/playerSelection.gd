extends Node2D

##Variable to store the max allowed players
var maxPlayerCount = 4

##Store the active players in an array for later use
var players = [-1, -1, -1, -1]

const PLAYER_COLOURS = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW]

##On start
func _ready() -> void:
	##Set the columns of the grid to the max player count
	get_node("%PlayerUIGrid").set_columns(maxPlayerCount)
	
	##Hide ready text
	get_node("%PressToReadyLabel").hide()
	
	get_node("%LevelNameLabel").hide()
	

##When input is detected,
func _input(event: InputEvent) -> void:
	
	##If player count is full, no need to add more players
	if (getActivePlayerSize() >= maxPlayerCount):
		return
	
	##Store the device that registered the input
	var localDeviceID = StaticFunctions.adjustForKeyboardInput(event)
	
	##If the device is not already one of our active players (and it has pressed a valid input),
	if not players.has(localDeviceID) and event.is_pressed():
		##Add the device ID to the player list
		var playerIndex = addPlayerToList(localDeviceID)
		
		##If the list is full, return
		if (playerIndex == -1):
			return
		
		##Load the UI display for the player
		var playerUI = preload("res://Prefab Scenes/menu_player_ui.tscn")
		var playerUIInstance = playerUI.instantiate()
		
		var localPlayerData = playerData.new(localDeviceID, assignPlayerColour(playerIndex))
		GameManager.AddPlayerToList(localPlayerData)
		
		##Set the player number in the scene to be accurate
		playerUIInstance.get_node("%PlayerNumLabel").text = "Player " + str(playerIndex + 1)
		playerUIInstance.setPlayerData(localPlayerData)
		
		##Add the instantiated UI display as a child of the grid
		get_node("%PlayerUIGrid").add_child(playerUIInstance)
		
		##If there is at least one player, show the ready text
		if (get_node("%PlayerUIGrid").get_child_count() >= 1):
			get_node("%PressToReadyLabel").show()
			get_node("%LevelNameLabel").show()
		else:
			get_node("%PressToReadyLabel").hide()
			get_node("%LevelNameLabel").hide()

##This function finds the earliest empty player slot and adds the given device ID
func addPlayerToList(deviceID: int) -> int:
	##Iterate through each player in the list
	for i in range(players.size()):
		##If a player does not exist at that index (-1), set that index to be the current player and return the index
		if (players[i] == -1):
			players[i] = deviceID
			
			return i
			
	##If no empty space was found, warn and return
	push_warning("Device ID " + str(deviceID) + " input detected, but max players already reached.")
	return -1
	
func getActivePlayerSize() -> int:
	var currentPlayerSize = 0
	
	for i in range(players.size()):
		if (players[i] != -1):
			currentPlayerSize += 1
			
	return currentPlayerSize
	
func assignPlayerColour(playerNum) -> Color:
	if (playerNum >= PLAYER_COLOURS.size()):
		push_warning("Invalid player number while trying to assign colour, assigning red.")
		return Color.RED
		
	return PLAYER_COLOURS[playerNum]
	
