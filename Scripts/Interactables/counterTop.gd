extends Node3D

class_name CounterTop

var inventory = null

func placeItem(itemToPlace) -> bool:
	if inventory != null:
		if inventory is Ingredient:
			if (itemToPlace is IngredientStack or itemToPlace is CookingPot):
				var result = itemToPlace.addIngredient(inventory)
				if (result == true):
					inventory = null
				return false
				
		elif inventory is IngredientStack or inventory is CookingPot:
			if (itemToPlace is Ingredient):
				var result = inventory.addIngredient(itemToPlace)
				return result
				
			elif (itemToPlace is IngredientStack or itemToPlace is CookingPot):
				inventory.addIngredient(itemToPlace)
				return false
		
		return false
		
	else:
		inventory = itemToPlace
		itemToPlace.reparent(self, true)
		
		itemToPlace.global_position = self.global_position + Vector3(0,1,0)
		itemToPlace.linear_velocity = Vector3.ZERO
		itemToPlace.angular_velocity = Vector3.ZERO
		
		itemToPlace.get_node("CollisionShape3D").disabled = false
		
		return true
		
func pickupItem():
	if inventory == null:
		return null
		
	else:
		var itemToReturn = inventory
		inventory = null
		return itemToReturn
