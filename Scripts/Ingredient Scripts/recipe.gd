extends Object

class_name Recipe

var ingredientsNeeded = []

func checkIfRecipeMatch(inputFood: IngredientStack):
	var ingredientsRemaining = ingredientsNeeded.duplicate(true)
	
	for inputIngredient: Ingredient in inputFood.currentIngredients:
		for localIngredient in ingredientsNeeded:
			if (inputIngredient.ingredient_type == localIngredient):
				ingredientsRemaining.erase(localIngredient)
				
	if (ingredientsRemaining.size() == 0):
		return true
		
	return false
