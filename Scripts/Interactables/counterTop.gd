extends Node3D

class_name CounterTop

var inventory = null

func placeItem(itemToPlace) -> bool:
	if inventory != null:
		return false
		
	else:
		inventory = itemToPlace
		itemToPlace.reparent(self, true)
		
		itemToPlace.global_position = self.global_position + Vector3(0,1,0)
		
		return true

func pickupItem():
	if inventory == null:
		return null
		
	else:
		var itemToReturn = inventory
		inventory = null
		return itemToReturn
