extends RayCast3D

@onready var hand =$"../hand"
var inventory = null;
var holding = false;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("Interact")):
		if (holding) and (!is_colliding()):
			putdown()
		elif (holding) and (is_colliding()):
			detect()
			if (detect() == "Counter"):
				store()
			elif (detect() == "Bin"):
				delete()
			else:
				pass
		elif (!holding) and (is_colliding()):
			detect()
			if (detect() == null):
				pickUp()
			elif(detect() == "Produce"):
				produce()
				pickUp()
		else:
			pass
	
	#print(holding)
	#print(inventory)
	if holding and inventory != null:
		inventory.global_position = hand.global_position
		inventory.global_rotation = hand.global_rotation
	
func pickUp():
	if is_colliding():
		var hit = get_collider()
		if (hit.is_in_group("Ingredient")):
			
				inventory = hit
				holding = true
				print("picked up")
				#print(holding)
				#print(inventory)

	
func putdown():
	if holding and inventory != null:
		
		inventory =null
		holding = false
		print("put down")
		if inventory is RigidBody3D:
				inventory.linear_velocity = Vector3.ZERO
				inventory.angular_velocity = Vector3.ZERO

func detect():
	var hit = get_collider()
	if (hit.is_in_group("Counter")):
		var type = "Counter"
		return type
	elif (hit.is_in_group("Bin")):
		var type = "Bin"
		return type
	elif (hit.is_in_group("Produce")):
		var type = "Produce"
		return type
	else:
		return null
	
func store():
	if is_colliding() and holding:
		var hit = get_collider()
		if (hit.is_in_group("Counter")):
			var location = hit.position
			inventory.position = location + Vector3(0,1,0)
			inventory = null
			holding = false
			print("counter put down")
			
var loader = null
func produce():
	if is_colliding():
		var hit = get_collider()
		if (hit.is_in_group("Produce")):
			if (hit.is_in_group("CheeseBin")):
				var loader = preload("res://Prefab Objects/cheese.tscn")
				var instance = loader.instantiate()
				instance.position = instance.position + Vector3(0,0.01,0)
				var parentPath = get_node("/root/Test/CheeseBin")
				parentPath.add_child(instance)
				print("produced cheese")
			elif (hit.is_in_group("TomatoBin")):
				var loader = preload("res://Prefab Objects/tomato.tscn")
				var instance = loader.instantiate()
				instance.position = instance.position + Vector3(0,0.01,0)
				var parentPath = get_node("/root/Test/TomatoBin")
				parentPath.add_child(instance)
				print("produced tomato")
			elif (hit.is_in_group("MushroomBin")):
				var loader = preload("res://Prefab Objects/mushroom.tscn")
				var instance = loader.instantiate()
				instance.position = instance.position + Vector3(0,0.01,0)
				var parentPath = get_node("/root/Test/MushroomBin")
				parentPath.add_child(instance)
				print("produced mushroom")
			elif (hit.is_in_group("OnionBin")):
				var loader = preload("res://Prefab Objects/onion.tscn")
				var instance = loader.instantiate()
				instance.position = instance.position + Vector3(0,0.01,0)
				var parentPath = get_node("/root/Test/OnionBin")
				parentPath.add_child(instance)
				print("produced onion")
			elif (hit.is_in_group("PotatoBin")):
				var loader = preload("res://Prefab Objects/potato.tscn")
				var instance = loader.instantiate()
				instance.position = instance.position + Vector3(0,0.01,0)
				var parentPath = get_node("/root/Test/PotatoBin")
				parentPath.add_child(instance)
				print("produced potato")
				
func delete():
	if is_colliding() and holding:
		var hit = get_collider()
		if (hit.is_in_group("Bin")):
			inventory.free()
			holding = false
			print("deleted")
