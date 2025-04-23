extends HoldableObject

class_name IngredientStack

enum StackType {
	INGREDIENTS,
	SOUP
}

var currentIngredients = []
var localStackType: StackType

func addIngredient(ingredientToAdd) -> bool:
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
		
	elif (ingredientToAdd is CookingPot):
		if (currentIngredients.size() == 0 and ingredientToAdd.isCooked):
			localStackType = StackType.SOUP
			currentIngredients = ingredientToAdd.finishedSoup.childIngredients
			get_node("%SoupMesh").visible = true
			ingredientToAdd.clearPot()
			return true
	
	elif (ingredientToAdd is IngredientStack):
		if (localStackType == StackType.INGREDIENTS):
			if (currentIngredients.size() == 0 and ingredientToAdd.currentIngredients.size() > 0):
				for otherIngredient in ingredientToAdd.currentIngredients:
					addIngredient(otherIngredient)
				
				ingredientToAdd.currentIngredients = []
				return true
		elif (localStackType == StackType.SOUP):
			if (currentIngredients.size() == 0 and ingredientToAdd.currentIngredients.size() > 0):
				for otherIngredient in ingredientToAdd.currentIngredients:
					addIngredient(otherIngredient)
				
				ingredientToAdd.currentIngredients = []
				
				get_node("%SoupMesh").visible = false
				ingredientToAdd.get_node("%SoupMesh").visible = true
				
				return true
			
		elif (currentIngredients.size() > 0 and ingredientToAdd.currentIngredients.size() == 0):
			for localIngredient in currentIngredients:
				ingredientToAdd.addIngredient(localIngredient)
			
			currentIngredients = []
			return true
	
	return false

func removeAllIngredients():
	get_node("%SoupMesh").visible = false
	
	for ing in currentIngredients:
		ing.free()
		currentIngredients = []
