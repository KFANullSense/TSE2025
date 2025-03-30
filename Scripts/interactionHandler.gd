extends RayCast3D

@onready var hand =$"../hand"
var inventory = null;
var holding = false;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("Interact")):
		if (holding):
			putdown()
		else:
			pickUp()
	
	print(holding)
	print(inventory)
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
				print(holding)
				print(inventory)

	
func putdown():
	if holding and inventory != null:
		
		inventory =null
		holding = false
		print("put down")
		if inventory is RigidBody3D:
				inventory.linear_velocity = Vector3.ZERO
				inventory.angular_velocity = Vector3.ZERO
				
