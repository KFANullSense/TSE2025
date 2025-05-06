extends RayCast3D

class_name InteractionHandler

@onready var hand =$"../hand"
var inventory = null;
var holding = false;

func _input(event: InputEvent) -> void:
	if (get_parent().canMove):
		var inputDeviceID = StaticFunctions.adjustForKeyboardInput(event)
		
		if inputDeviceID != get_parent().localDeviceID or get_parent().localDeviceID == -1:
			return

		if (Input.is_action_just_pressed("Interact" + str(get_parent().localDeviceID))):
			interactAction()
			
		if (Input.is_action_just_pressed("use" + str(get_parent().localDeviceID))):
			useAction()

func interactAction() -> void:
	if (is_colliding()):
		var hit = get_collider()
		
		if hit is Ingredient or hit is IngredientStack or hit is CookingPot:
			if (not holding):
				pickUp(hit)
		elif hit is CounterTop or hit is StoveTop:
			if (holding):
				store(hit)
			else:
				collectFromCounter(hit)
		elif hit.is_in_group("Bin"):
			if (holding):
				delete()
		elif hit is ProduceBin:
			if (not holding):
				produce(hit)
				
		elif hit is HandInCounter:
			if (holding):
				handIn(hit)
				
	else:
		if (holding):
			putDown()
			
func useAction():
	if (is_colliding()):
		var hit = get_collider()
		
		if hit is ChoppingCounter:
			var player: PlayerMovement = get_parent() as PlayerMovement
			player.canMove = false
			await hit.chopIngredient()
			player.canMove = true
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#print(holding)
	#print(inventory)
	if holding and inventory != null:
		inventory.global_position = hand.global_position
		inventory.global_rotation = hand.global_rotation
	
func pickUp(objectToPickUp):
	inventory = objectToPickUp
	inventory.get_node("CollisionShape3D").disabled = true
	holding = true
	print("picked up")

	
func putDown():
	if holding and inventory != null:
		if inventory is RigidBody3D:
				inventory.get_node("CollisionShape3D").disabled = false
				inventory.linear_velocity = Vector3.ZERO
				inventory.angular_velocity = Vector3.ZERO
				
		inventory = null
		holding = false
		print("put down")
				
func store(localCounter: CounterTop):
	var result = localCounter.placeItem(inventory)
	
	if (result == true):
		inventory = null
		holding = false
		print("counter put down")
		
func collectFromCounter(localCounter: CounterTop):
	var result = localCounter.pickupItem()
	
	if result != null:
		result.reparent(get_tree().root, true)
		pickUp(result)
			
func produce(localProduceBin):
	pickUp(localProduceBin.spawnObject())
				
func handIn(localCounter: HandInCounter):
	var result = localCounter.handInItem(inventory)
	
	if result == true:
		inventory.free()
		holding = false
				
func delete():
	if (inventory is IngredientStack):
		inventory.removeAllIngredients()
	else:
		inventory.free()
		holding = false
		print("deleted")
