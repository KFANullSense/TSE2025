extends InteractionHandler

func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("Interact-2")):
		interactAction()
