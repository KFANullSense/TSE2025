extends Node

class_name CookedFood

enum FoodType {
	SOUP
}

var childIngredients: Array[Ingredient.IngredientType]
var localFoodType: FoodType

func _init(foodType: FoodType, localIngredients: Array[Ingredient.IngredientType]) -> void:
	childIngredients = localIngredients
	localFoodType = foodType
