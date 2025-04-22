extends Node3D

class_name CookingPot

const MAX_ITEMS: int = 3
const TIME_TO_COOK: float = 15.0

var localIngredients: Array[Ingredient]
var fill_meshes: Array[MeshInstance3D]
var cookProgress: float = 0.0

var finishedSoup: CookedFood
var isCooked = false
var isOnStove = true

func add_ingredient(ingredientToAdd) -> bool:
	if localIngredients.size() >= MAX_ITEMS:
		return false
	
	if (ingredientToAdd is Ingredient):
		if not ingredientToAdd.is_chopped:
			return false
			
		localIngredients.append(ingredientToAdd)
	
	if (ingredientToAdd is IngredientStack):
		if localIngredients.size() + ingredientToAdd.currentIngredients.size() >= MAX_ITEMS:
			return false
		
		if (ingredientToAdd.localStackType != IngredientStack.StackType.INGREDIENTS):
			return false
			
		for localIngredient in ingredientToAdd.currentIngredients:
			if not localIngredient.is_chopped:
				return false
				
		for localIngredient in ingredientToAdd.currentIngredients:
			localIngredients.append(localIngredient)
			
		ingredientToAdd.removeAllIngredients()
	
	fill_meshes[localIngredients.size() - 1].visible = true
	return true

func _process(delta: float) -> void:
	if (localIngredients.size() > 0 and isCooked == false and isOnStove):
		cookProgress += delta
		
		if (cookProgress > TIME_TO_COOK):
			isCooked = true
			var finishedIngredientList: Array[Ingredient.IngredientType]
			for localIngredient in localIngredients:
				finishedIngredientList.append(localIngredient.ingredient_type)
			finishedSoup = CookedFood.new(CookedFood.FoodType.SOUP, finishedIngredientList)
			
	else:
		cookProgress = 0

func set_fill_color(mesh: MeshInstance3D, type: String):
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
		_:
			color = Color.LIGHT_GRAY

	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.set_surface_override_material(0, mat)

func clearPot():
	localIngredients = []
	for fillMesh in fill_meshes:
		fillMesh.visible = false
		
	isCooked = false
