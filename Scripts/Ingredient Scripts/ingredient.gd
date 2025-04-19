extends Node3D

var is_chopped: bool = false
var ingredient_type: String = "onion" # Set this in each ingredient instance

@onready var raw_mesh = $RawMesh
@onready var chopped_mesh = $ChoppedMesh

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
