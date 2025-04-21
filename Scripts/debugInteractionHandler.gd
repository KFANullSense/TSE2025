extends RayCast3D

@onready var hand =$"../hand"
var inventory = null;
var holding = false;

func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("Interact-2")):
		interactAction()

func interactAction() -> void:
	if (is_colliding()):
		var hit = get_collider()
		
		if hit is Ingredient:
			if (not holding):
				pickUp(hit)
		elif hit is CounterTop:
			if (holding):
				store(hit)
			else:
				collectFromCounter(hit)
		elif hit.is_in_group("Bin"):
			if (holding):
				delete()
		elif hit.is_in_group("Produce"):
			if (not holding):
				produce(hit)
		else:
			if (holding):
				putDown()
			
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
		inventory = null
		holding = false
		print("put down")
		if inventory is RigidBody3D:
				inventory.get_node("CollisionShape3D").disabled = false
				inventory.linear_velocity = Vector3.ZERO
				inventory.angular_velocity = Vector3.ZERO
				
func store(localCounter: CounterTop):
	var result = localCounter.placeItem(inventory)
	
	if (result == true):
		inventory.linear_velocity = Vector3.ZERO
		inventory.angular_velocity = Vector3.ZERO
		
		inventory.get_node("CollisionShape3D").disabled = false
		
		inventory = null
		holding = false
		print("counter put down")
		
func collectFromCounter(localCounter: CounterTop):
	var result = localCounter.pickupItem()
	
	if result != null:
		result.reparent(self, true)
		pickUp(result)
			
var loader = null
func produce(localProduceBin):
	if (localProduceBin.is_in_group("CheeseBin")):
		loader = preload("res://Prefab Objects/cheese.tscn")
		var instance = loader.instantiate()
		instance.position = instance.position + Vector3(0,0.01,0)
		var parentPath = get_node("/root/Test/CheeseBin")
		parentPath.add_child(instance)
		print("produced cheese")
	elif (localProduceBin.is_in_group("TomatoBin")):
		loader = preload("res://Prefab Objects/tomato.tscn")
		var instance = loader.instantiate()
		instance.position = instance.position + Vector3(0,0.01,0)
		var parentPath = get_node("/root/Test/TomatoBin")
		parentPath.add_child(instance)
		print("produced tomato")
	elif (localProduceBin.is_in_group("MushroomBin")):
		loader = preload("res://Prefab Objects/mushroom.tscn")
		var instance = loader.instantiate()
		instance.position = instance.position + Vector3(0,0.01,0)
		var parentPath = get_node("/root/Test/MushroomBin")
		parentPath.add_child(instance)
		print("produced mushroom")
	elif (localProduceBin.is_in_group("OnionBin")):
		loader = preload("res://Prefab Objects/onion.tscn")
		var instance = loader.instantiate()
		instance.position = instance.position + Vector3(0,0.01,0)
		var parentPath = get_node("/root/Test/OnionBin")
		parentPath.add_child(instance)
		print("produced onion")
	elif (localProduceBin.is_in_group("PotatoBin")):
		loader = preload("res://Prefab Objects/potato.tscn")
		var instance = loader.instantiate()
		instance.position = instance.position + Vector3(0,0.01,0)
		var parentPath = get_node("/root/Test/PotatoBin")
		parentPath.add_child(instance)
		print("produced potato")
				
func delete():
	if (inventory is IngredientStack):
		inventory.removeAllIngredients()
	else:
		inventory.free()
		holding = false
		print("deleted")
