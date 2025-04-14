extends TextureRect

class_name menuPlayerUI

var localDeviceID = -1
var isReady = false

func _ready() -> void:
	get_node("%PlayerNumLabel").get_child(0).hide()

func _input(event: InputEvent) -> void:
	var inputDeviceID = StaticFunctions.adjustForKeyboardInput(event)
	
	if inputDeviceID != localDeviceID or localDeviceID == -1:
		return

	if (Input.is_action_just_pressed("start")):
		toggleReady()

func setDeviceID(deviceID: int) -> void:
	localDeviceID = deviceID

func toggleReady() -> void:
	if isReady:
		isReady = false
		get_node("%PlayerNumLabel").get_child(0).hide()
	else:
		isReady = true
		get_node("%PlayerNumLabel").get_child(0).show()
