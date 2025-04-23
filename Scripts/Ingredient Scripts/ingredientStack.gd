extends HoldableObject

class_name IngredientStack

enum StackType {
	EMPTY,
	INGREDIENTS,
	SOUP
}

var currentIngredients = []
var localStackType: StackType = StackType.EMPTY
@onready var localIngredientDisplay: IngredientDisplay = get_node("IngredientDisplay")

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
				localIngredientDisplay.updateIngredientSprites(currentIngredients)
				return true
		
	elif (ingredientToAdd is CookingPot):
		if (currentIngredients.size() == 0 and ingredientToAdd.isCooked):
			localStackType = StackType.SOUP
			currentIngredients = ingredientToAdd.finishedSoup.childIngredients
			get_node("%SoupMesh").visible = true
			ingredientToAdd.clearPot()
			localIngredientDisplay.updateIngredientSprites(currentIngredients)
			return true
	
	elif (ingredientToAdd is IngredientStack):
		if (localStackType == StackType.EMPTY):
			if (ingredientToAdd.localStackType == StackType.INGREDIENTS):
				if (currentIngredients.size() == 0 and ingredientToAdd.currentIngredients.size() > 0):
					for otherIngredient in ingredientToAdd.currentIngredients:
						addIngredient(otherIngredient)
					
					ingredientToAdd.removeAllIngredients(false)
					return true
			
			elif (ingredientToAdd.localStackType == StackType.SOUP):
				if (currentIngredients.size() == 0 and ingredientToAdd.currentIngredients.size() > 0):
					localStackType = StackType.SOUP
					currentIngredients = ingredientToAdd.currentIngredients
					get_node("%SoupMesh").visible = true
					localIngredientDisplay.updateIngredientSprites(currentIngredients)
					
					ingredientToAdd.removeAllIngredients(false)
					
					return true
		
		elif (ingredientToAdd.localStackType == StackType.EMPTY):
			if (localStackType == StackType.INGREDIENTS):
				if (currentIngredients.size() > 0 and ingredientToAdd.currentIngredients.size() == 0):
					for localIngredient in currentIngredients:
						ingredientToAdd.addIngredient(localIngredient)
					
					removeAllIngredients(false)
					return true
			
			elif (localStackType == StackType.SOUP):
				if (currentIngredients.size() > 0 and ingredientToAdd.currentIngredients.size() == 0):
					ingredientToAdd.localStackType = StackType.SOUP
					ingredientToAdd.currentIngredients = currentIngredients
					ingredientToAdd.get_node("%SoupMesh").visible = true
					ingredientToAdd.localIngredientDisplay.updateIngredientSprites(currentIngredients)
					
					removeAllIngredients(false)
					
					return true
		
	
	return false

func removeAllIngredients(shouldDeleteIngredients: bool = true):
	get_node("%SoupMesh").visible = false
	
	if (shouldDeleteIngredients):
		for ing in currentIngredients:
			ing.free()
	
	currentIngredients = []
	
	localStackType = StackType.EMPTY
		
	localIngredientDisplay.updateIngredientSprites(currentIngredients)
