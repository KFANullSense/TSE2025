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
			if (ingredientToAdd.is_chopped):
				localStackType = StackType.INGREDIENTS
				ingredientToAdd.reparent(self, true)
				ingredientToAdd.freeze = true
				ingredientToAdd.get_node("CollisionShape3D").disabled = true
				ingredientToAdd.global_position = self.global_position + Vector3(0, 0 + 0.5 * (currentIngredients.size()),0)
				ingredientToAdd.linear_velocity = Vector3.ZERO
				ingredientToAdd.angular_velocity = Vector3.ZERO
				currentIngredients.append(ingredientToAdd)
				return true
		
	elif (ingredientToAdd is CookedFood):
		if (ingredientToAdd.localFoodType == CookedFood.FoodType.SOUP and currentIngredients.size() == 0):
			localStackType = StackType.SOUP
			currentIngredients = ingredientToAdd.childIngredients.duplicate(true)
			return true
	
	elif (ingredientToAdd is IngredientStack):
		if (currentIngredients.size() == 0 and ingredientToAdd.currentIngredients.size() > 0):
			for otherIngredient in ingredientToAdd.currentIngredients:
				addIngredient(otherIngredient)
			
			ingredientToAdd.currentIngredients = []
			return true
			
		elif (currentIngredients.size() > 0 and ingredientToAdd.currentIngredients.size() == 0):
			for localIngredient in currentIngredients:
				ingredientToAdd.addIngredient(localIngredient)
			
			currentIngredients = []
			return true
	
	else:
		push_warning("Trying to add an invalid ingredient to a stack.")
		return false

func removeAllIngredients():
	for ing in currentIngredients:
		ing.free()
		currentIngredients = []
