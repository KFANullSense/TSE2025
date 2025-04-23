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
	var skipToNextLoop = false
	
	for inputIngredient in inputFood.currentIngredients:	
		for localIngredient in finalItemIngredients:
			if (inputIngredient == localIngredient):
				ingredientsRemaining.erase(localIngredient)
				break
		
				
	if (ingredientsRemaining.size() == 0):
		return true
		
	return false

func initializeUIObject(uiObjectRef):
	recipeUIObject = uiObjectRef
	
	if (finalItemType == IngredientStack.StackType.SOUP):
		recipeUIObject.get_node("%MainImage").texture = SpriteLoader.soupSprite
		
	var ingredientSprites = recipeUIObject.get_node("%IngredientHolder").get_children()
	
	for i in range(finalItemIngredients.size()):
		var spriteToSet: Texture2D
		
		match finalItemIngredients[i]:
			Ingredient.IngredientType.ONION:
				spriteToSet = SpriteLoader.onionSprite
			Ingredient.IngredientType.MUSHROOM:
				spriteToSet = SpriteLoader.mushroomSprite
			Ingredient.IngredientType.TOMATO:
				spriteToSet = SpriteLoader.tomatoSprite
	
		ingredientSprites[i].texture = spriteToSet
