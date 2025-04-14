extends CharacterBody3D

const SPEED = 5.0
const ROTATION_SPEED = 10.0

var localDeviceID: int = -1

func handleMovement(delta: float):
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("leftInput" + str(localDeviceID), "rightInput" + str(localDeviceID), "upInput" + str(localDeviceID), "downInput" + str(localDeviceID))
	var direction := ( Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir.length() > 0:
		var target_pos = global_position - Vector3(input_dir.x, 0, input_dir.y)
		var target_transform = transform.looking_at(target_pos, Vector3.UP)
		transform.basis = transform.basis.slerp(target_transform.basis, ROTATION_SPEED * delta)
	
	
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	
func _physics_process(delta: float) -> void:
	handleMovement(delta)


func updateDeviceID(newID: int):
	localDeviceID = newID
