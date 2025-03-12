extends Area3D

func _ready():
	pass

func _proess(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Ingredient") and Input.is_action_pressed("Interact"):
		body.queue_free()
		print("Object Deleted")
		
