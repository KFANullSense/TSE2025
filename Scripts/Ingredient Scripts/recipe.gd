extends Object

class_name Recipe

var finalItemType: IngredientStack.StackType
var finalItemIngredients: Array[Ingredient.IngredientType]

func _init(localFinalItemType: IngredientStack.StackType, localFinalItemIngredients: Array[Ingredient.IngredientType]) -> void:
	finalItemType = localFinalItemType
	finalItemIngredients = localFinalItemIngredients

func checkIfRecipeMatch(inputFood: IngredientStack):
	if (inputFood.localStackType != finalItemType):
		return false
	
	var ingredientsRemaining = finalItemIngredients.duplicate(true)
	
	for inputIngredient in inputFood.currentIngredients:
		for localIngredient in finalItemIngredients:
			if (inputIngredient.ingredient_type == localIngredient):
				ingredientsRemaining.erase(localIngredient)
				
	if (ingredientsRemaining.size() == 0):
		return true
		
	return false
