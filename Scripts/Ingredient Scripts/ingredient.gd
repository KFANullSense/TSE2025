extends Node3D

class_name Ingredient

enum IngredientType {
	ONION,
	TOMATO,
	MUSHROOM,
	CHEESE,
	POTATO,
}

var is_chopped: bool = false
var ingredient_type: IngredientType = IngredientType.ONION

@onready var raw_mesh = get_node("%RawMesh")
@onready var chopped_mesh = get_node("%ChoppedMesh")

func _ready():
	# Show correct mesh on load
	raw_mesh.visible = not is_chopped
	chopped_mesh.visible = is_chopped

func is_choppable() -> bool:
	return not is_chopped

func on_chop(delta: float):
	# Optional: Add sound, particles, etc.
	pass

func finish_chopping():
	if not is_chopped:
		is_chopped = true
		raw_mesh.visible = false
		chopped_mesh.visible = true
		print("Chopped:", ingredient_type)
