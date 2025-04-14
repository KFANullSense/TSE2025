extends Node2D

var playerList = []

func AddPlayerToList(playerToAdd):
	if (playerToAdd is not menuPlayerUI):
		push_warning("GameManager: Attempting to add a player that is incorrectly typed.")
		return
	
	playerList.append(playerToAdd)
	
func CheckIfAllPlayersReady():
	for localPlayer in playerList:
		if (not localPlayer.isReady):
			return false
		
	return true
