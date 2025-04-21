extends Node3D

const MAX_ITEMS = 3

var ingredient_type: String = ""
var ingredient_count: int = 0
var fill_meshes: Array[MeshInstance3D] = []

@onready var pot_mesh = $PotMesh
@onready var fill1 = $Fill1
@onready var fill2 = $Fill2
@onready var fill3 = $Fill3

func _ready():
	fill_meshes = [fill1, fill2, fill3]
	for mesh in fill_meshes:
		mesh.visible = false

func add_ingredient(ingredient: Node) -> bool:
	# Must be chopped and have a known ingredient type
	if not ingredient.has_method("is_chopped") or not ingredient.is_chopped:
		return false
	if not ingredient.has_variable("ingredient_type"):
		return false
	
	var type = ingredient.ingredient_type
	
	# First item sets the required type
	if ingredient_count == 0:
		ingredient_type = type
	elif type != ingredient_type:
		return false # Reject different type

	if ingredient_count >= MAX_ITEMS:
		return false
	
	# Add the item visually
	fill_meshes[ingredient_count].visible = true
	set_fill_color(fill_meshes[ingredient_count], type)
	ingredient_count += 1
	return true

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
