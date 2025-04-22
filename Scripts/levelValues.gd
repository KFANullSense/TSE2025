extends Node

class_name LevelValues

var LEVEL_VALUES = [
	#Level 1 (Index 0)
	Level.new(150, [20, 40, 120], [
		Recipe.new(IngredientStack.StackType.SOUP,
			[Ingredient.IngredientType.ONION,
			Ingredient.IngredientType.ONION,
			Ingredient.IngredientType.ONION])
	]),
	
	#Level 2 (Index 1)
	Level.new(240, [20, 60, 210], [
		Recipe.new(IngredientStack.StackType.SOUP,
			[Ingredient.IngredientType.ONION,
			Ingredient.IngredientType.ONION,
			Ingredient.IngredientType.ONION]),
		Recipe.new(IngredientStack.StackType.SOUP,
			[Ingredient.IngredientType.TOMATO,
			Ingredient.IngredientType.TOMATO,
			Ingredient.IngredientType.TOMATO])
	]),
	
	#Level 3 (Index 2)
	Level.new(240, [60, 120, 260], [
		Recipe.new(IngredientStack.StackType.SOUP,
			[Ingredient.IngredientType.ONION,
			Ingredient.IngredientType.ONION,
			Ingredient.IngredientType.ONION]),
		Recipe.new(IngredientStack.StackType.SOUP,
			[Ingredient.IngredientType.TOMATO,
			Ingredient.IngredientType.TOMATO,
			Ingredient.IngredientType.TOMATO]),
		Recipe.new(IngredientStack.StackType.SOUP,
			[Ingredient.IngredientType.MUSHROOM,
			Ingredient.IngredientType.MUSHROOM,
			Ingredient.IngredientType.MUSHROOM])
	])
]
