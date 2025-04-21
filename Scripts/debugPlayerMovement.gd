extends PlayerMovement

func handleMovement(delta: float):
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("leftInput-2", "rightInput-2", "upInput-2", "downInput-2")
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
