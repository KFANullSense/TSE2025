extends CounterTop

class_name ChoppingCounter

const CHOPPING_TIME: float = 2.0

var chop_progress: float = 0.0
var isChopping: bool = false
@onready var localProgressBar: ProgressBar = get_node("ProgressBar").get_node("%BarViewport/ProgressBar")

func _ready() -> void:
	localProgressBar.visible = false

func chopIngredient():
	if (inventory is Ingredient):
		if (not inventory.is_chopped):
			localProgressBar.visible = true
			chop_progress = 0
			
			while (chop_progress < CHOPPING_TIME):
				localProgressBar.value = chop_progress / CHOPPING_TIME
				await Engine.get_main_loop().process_frame
				chop_progress += get_process_delta_time()
				
			localProgressBar.visible = false
			inventory.finish_chopping()
			chop_progress = 0
			
func placeItem(itemToPlace) -> bool:
	if (chop_progress != 0):
		return false
	
	return super(itemToPlace)

func pickupItem():
	if (chop_progress != 0):
		return null
	
	chop_progress = 0
	return super()
