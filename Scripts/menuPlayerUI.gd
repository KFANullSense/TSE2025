extends TextureRect

class_name menuPlayerUI

var localPlayerData: playerData
var isReady = false

func _ready() -> void:
	get_node("%PlayerNumLabel").get_child(0).hide()

func _input(event: InputEvent) -> void:
	var inputDeviceID = StaticFunctions.adjustForKeyboardInput(event)
	
	if inputDeviceID != localPlayerData.localDeviceID or localPlayerData.localDeviceID == -1:
		return

	if (Input.is_action_just_pressed("start")):
		toggleReady()

func setPlayerData(dataToSet: playerData) -> void:
	localPlayerData = dataToSet

func toggleReady() -> void:
	if localPlayerData.isReady:
		localPlayerData.isReady = false
		get_node("%PlayerNumLabel").get_child(0).hide()
	else:
		localPlayerData.isReady = true
		get_node("%PlayerNumLabel").get_child(0).show()
		GameManager.AttemptStartGame()
