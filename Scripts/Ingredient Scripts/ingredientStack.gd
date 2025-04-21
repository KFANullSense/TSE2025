extends HoldableObject

var currentIngredients = []

func addIngredient(ingredientToAdd: Ingredient):
	currentIngredients.append(ingredientToAdd)
	ingredientToAdd.get_parent().remove_child(ingredientToAdd)
	add_child(ingredientToAdd)
