extends Node3D

class_name ProduceBin

@export var ObjectToSpawn: PackedScene
	

func spawnObject():
	var localObject: Node3D = ObjectToSpawn.instantiate()
	
	localObject.visible = true
	
	get_tree().root.add_child(localObject)
	
	return localObject
