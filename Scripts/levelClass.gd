extends Node

class_name Level

var timeLength: int
var starThresholds: Array[int]
var recipeList: Array[Recipe]

func _init(localLength: int, localThresholds: Array[int], localRecipeList: Array[Recipe]):
	timeLength = localLength
	starThresholds = localThresholds
	recipeList = localRecipeList
