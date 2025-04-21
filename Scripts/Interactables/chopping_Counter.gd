extends Node3D

@export var chopping_time_required: float = 2.0 # Total time required to chop in seconds

var current_ingredient: Node = null
var chop_progress: float = 0.0

@onready var chop_spot = $ChopSpot # A marker or position to place the ingredient

func place_ingredient(ingredient: Node) -> bool:
	if current_ingredient == null and ingredient.has_method("is_choppable") and ingredient.is_choppable():
		current_ingredient = ingredient
		chop_progress = 0.0
		add_child(ingredient)
		ingredient.global_transform = chop_spot.global_transform
		return true
	return false

func remove_ingredient() -> Node:
	var item = current_ingredient
	current_ingredient = null
	chop_progress = 0.0
	return item

# Called externally
func do_interact(delta: float):
	if current_ingredient and current_ingredient.has_method("on_chop"):
		chop_progress += delta
		current_ingredient.on_chop(delta)
		
		if chop_progress >= chopping_time_required:
			if current_ingredient.has_method("finish_chopping"):
				current_ingredient.finish_chopping()
