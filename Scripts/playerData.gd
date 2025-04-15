class_name playerData

var localDeviceID = -1
var isReady = false
var playerColor: Color = Color.WHITE

func _init(deviceID: int, initColor: Color) -> void:
	localDeviceID = deviceID
	playerColor = initColor
