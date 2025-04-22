extends Object

class_name Recipe

var finalItemType: IngredientStack.StackType
var finalItemIngredients: Array[Ingredient.IngredientType]

var recipeUIObject = null

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

func initializeUIObject(uiObjectRef):
	recipeUIObject = uiObjectRef
	
	if (finalItemType == IngredientStack.StackType.SOUP):
		recipeUIObject.get_node("%MainImage").texture = SpriteLoader.soupSprite
		
	var ingredientSprites = recipeUIObject.get_node().get_children()
	
	for i in range(finalItemIngredients.size()):
		var spriteToSet: Texture2D
		
		match finalItemIngredients[i]:
			Ingredient.IngredientType.ONION:
				SpriteLoader.onionSprite
			Ingredient.IngredientType.MUSHROOM:
				SpriteLoader.mushroomSprite
			Ingredient.IngredientType.TOMATO:
				SpriteLoader.tomatoSprite
	
		ingredientSprites[i].texture = spriteToSet
