extends Node2D

class_name StaticFunctions

##Due to keyboard and the first controller both sharing device ID 0, we manually override keyboard to be -2
static func adjustForKeyboardInput(event: InputEvent) -> int:
	var deviceID = event.device
	
	if (deviceID == 0 and not (event is InputEventJoypadButton or event is InputEventJoypadMotion)):
		deviceID = -2
		
	return deviceID
