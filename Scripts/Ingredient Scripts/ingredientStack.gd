extends HoldableObject

class_name IngredientStack

enum StackType {
	INGREDIENTS,
	SOUP
}

var currentIngredients = []
var localStackType: StackType

func addIngredient(ingredientToAdd):
	if (ingredientToAdd is Ingredient):
		if (currentIngredients.size() == 0 or localStackType == StackType.INGREDIENTS):
			localStackType = StackType.INGREDIENTS
			currentIngredients.append(ingredientToAdd)
			ingredientToAdd.reparent(self, true)
		
	elif (ingredientToAdd is CookedFood):
		if (ingredientToAdd.localFoodType == CookedFood.FoodType.SOUP and currentIngredients.size() == 0):
			localStackType = StackType.SOUP
			currentIngredients = ingredientToAdd.childIngredients.duplicate(true)
			
	else:
		push_warning("Trying to add an invalid ingredient to a stack.")

func removeAllIngredients():
	for ing in currentIngredients:
		ing.free()
		currentIngredients = []
