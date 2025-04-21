extends HoldableObject

class_name IngredientStack

var currentIngredients = []

func addIngredient(ingredientToAdd):
	if (ingredientToAdd is Ingredient):
		currentIngredients.append(ingredientToAdd)
		ingredientToAdd.get_parent().remove_child(ingredientToAdd)
		add_child(ingredientToAdd)
		
	elif (ingredientToAdd is CookedFood):
		if (ingredientToAdd.localFoodType == CookedFood.FoodType.SOUP and currentIngredients.size() == 0):
			currentIngredients.append(ingredientToAdd)
			
	else:
		push_warning("Trying to add an invalid ingredient to a stack.")

func removeAllIngredients():
	for ing in currentIngredients:
		ing.free()
		currentIngredients = []
