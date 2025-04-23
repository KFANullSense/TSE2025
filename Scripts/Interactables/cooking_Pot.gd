extends Node3D

class_name CookingPot

const MAX_ITEMS: int = 3
const TIME_TO_COOK: float = 15.0

var localIngredients: Array[Ingredient.IngredientType]
@export var fill_meshes: Array[MeshInstance3D]
var cookProgress: float = 0.0

var finishedSoup: CookedFood
var isCooked = false
var isOnStove = true

@onready var localIngredientDisplay: IngredientDisplay = get_node("IngredientDisplay")
@onready var localProgressBar: ProgressBar = get_node("ProgressBar").get_node("%BarViewport/ProgressBar")

func _ready() -> void:
	localProgressBar.visible = false

func addIngredient(ingredientToAdd) -> bool:
	if localIngredients.size() >= MAX_ITEMS:
		return false
	
	if (ingredientToAdd is Ingredient):
		if isCooked:
			return false
		
		if not ingredientToAdd.is_chopped:
			return false
			
		localIngredients.append(ingredientToAdd.ingredient_type)
		
		ingredientToAdd.free()
	
	elif (ingredientToAdd is IngredientStack):
		if (isCooked):
			ingredientToAdd.addIngredient(self)
				
			return false
		
		if localIngredients.size() + ingredientToAdd.currentIngredients.size() >= MAX_ITEMS:
			return false
		
		if (ingredientToAdd.localStackType != IngredientStack.StackType.INGREDIENTS):
			return false
			
		for localIngredient in ingredientToAdd.currentIngredients:
			if not localIngredient.is_chopped:
				return false
				
		for localIngredient in ingredientToAdd.currentIngredients:
			localIngredients.append(localIngredient.ingredient_type)
			
		ingredientToAdd.removeAllIngredients()
	
	else:
		return false
	
	localIngredientDisplay.updateIngredientSprites(localIngredients)
	fill_meshes[localIngredients.size() - 1].visible = true
	return true

func _process(delta: float) -> void:
	if (localIngredients.size() > 0 and isCooked == false and isOnStove):
		localProgressBar.visible = true
		localProgressBar.value = cookProgress / TIME_TO_COOK
		
		cookProgress += delta
		
		if (cookProgress > TIME_TO_COOK):
			localProgressBar.visible = false
			isCooked = true
			var finishedIngredientList: Array[Ingredient.IngredientType]
			for localIngredient in localIngredients:
				finishedIngredientList.append(localIngredient)
			finishedSoup = CookedFood.new(CookedFood.FoodType.SOUP, finishedIngredientList)
			set_fill_color("onion")
			localIngredients = []
			
	else:
		cookProgress = 0
		localProgressBar.visible = false

func set_fill_color(type: String):
	var color := Color.WHITE

	match type.to_lower():
		"onion":
			color = Color(0.4, 0.25, 0.1) # Brown
		"tomato":
			color = Color.RED
		"carrot":
			color = Color.ORANGE
		"lettuce":
			color = Color(0.2, 0.6, 0.2) # Green
		"blank":
			color = Color.LIGHT_GRAY

	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	for fillMesh in fill_meshes:
		fillMesh.set_surface_override_material(0, mat)

func clearPot():
	localIngredients = []
	for fillMesh in fill_meshes:
		fillMesh.visible = false
		fillMesh.set_surface_override_material(0, null)
		
	finishedSoup = null
	isCooked = false
	localIngredientDisplay.updateIngredientSprites(localIngredients)
