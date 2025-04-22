extends CounterTop

class_name ChoppingCounter

const CHOPPING_TIME: float = 2.0

var chop_progress: float = 0.0

func chopIngredient():
	if (inventory is Ingredient):
		await get_tree().create_timer(CHOPPING_TIME).timeout
		inventory.finish_chopping()
