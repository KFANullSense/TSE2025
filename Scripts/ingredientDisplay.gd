extends Sprite3D

class_name IngredientDisplay

@onready var localSprites: Array[Node] = get_node("%SpriteViewport").get_children()

func _ready() -> void:
	updateIngredientSprites([])

func updateIngredientSprites(ingredientList):
	for i in range (localSprites.size()):
		var textureToChangeTo: Texture = null
		if (i < ingredientList.size()):
			var ingredientToMatch: Ingredient.IngredientType
			
			if (ingredientList[i] is Ingredient):
				ingredientToMatch = ingredientList[i].ingredient_type
				print(ingredientToMatch)
			else:
				ingredientToMatch = ingredientList[i]
			
			match ingredientToMatch:
				Ingredient.IngredientType.ONION:
					textureToChangeTo = SpriteLoader.onionSprite
				Ingredient.IngredientType.MUSHROOM:
					textureToChangeTo = SpriteLoader.mushroomSprite
				Ingredient.IngredientType.TOMATO:
					textureToChangeTo = SpriteLoader.tomatoSprite
			
		localSprites[i].texture = textureToChangeTo
