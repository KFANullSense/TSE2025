extends CounterTop

class_name StoveTop

var cookingPotScene = preload("res://Prefab Objects/Cooking_Tools/Cooking_Pot.tscn")

func _ready() -> void:
	inventory = cookingPotScene.instantiate()
	self.add_child(inventory)
	inventory.global_position = self.global_position + Vector3(0,1,0)

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
		
		if (itemToPlace is CookingPot):
			itemToPlace.isOnStove = true
		
		return true
		
func pickupItem():
	if inventory == null:
		return null
		
	else:
		if (inventory is CookingPot):
			inventory.isOnStove = false
		
		var itemToReturn = inventory
		inventory = null
		return itemToReturn
