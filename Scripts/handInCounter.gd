extends Node3D

class_name HandInCounter

func handInItem(itemToCheck) -> bool:
	if (itemToCheck is not IngredientStack):
		return false
	
	if itemToCheck.currentIngredients.size() <= 0:
		return false
		
	GameManager.HandInRecipe(itemToCheck)
	
	return true
