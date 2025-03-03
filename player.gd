extends CharacterBody2D

##Movement Values
var max_speed = 400
var accel = 1500
var decel = 600

##Input Variables
var localDeviceID = -1
var inputVector: Vector2 = Vector2.ZERO

var heldItem: HoldableObject = null

func _input(event: InputEvent) -> void:
	##Adjust for keyboard
	var inputDeviceID = StaticFunctions.adjustForKeyboardInput(event)
	
	if inputDeviceID != localDeviceID or localDeviceID == -1:
		return
		
	##Normalize and assign the current input vector for use within the movement script
	inputVector.x = int(Input.is_action_pressed("rightInput")) - int(Input.is_action_pressed("leftInput"))
	inputVector.y = int(Input.is_action_pressed("downInput")) - int(Input.is_action_pressed("upInput"))
	inputVector = inputVector.normalized()

	##If interact key is pressed, check the current held item state and perform the appropriate action
	if (Input.is_action_just_pressed("interact")):
		if (heldItem == null):
			pickup_item()
		else:
			drop_item()

##When the physics process runs, run our movement function
func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta):
	##If player is not currently pressing any input keys, slow down to a stop
	if inputVector == Vector2.ZERO:
		##If player is still moving, deccelerate
		if (velocity.length() > (decel * delta)):
			velocity -= velocity.normalized() * (decel * delta)
		##If the player has reached the decel limit, stop completely
		else:
			velocity = Vector2.ZERO
	
	##If the player is pressing an input, accelerate up to the max speed in the desired direction
	else:
		velocity += (inputVector * accel * delta)
		velocity = velocity.limit_length(max_speed)
	
	move_and_slide()

func drop_item():
	return
	
func pickup_item():
	return
