extends Node3D
class_name Item

@export var item_id: String = "RawMeat"

func _ready():
	var mesh = MeshInstance3D.new()
	var box = BoxMesh.new()
	var mat = StandardMaterial3D.new()
	
	if item_id == "RawMeat":
		box.size = Vector3(0.5, 0.1, 0.5)
		mat.albedo_color = Color(0.8, 0.2, 0.2)
	elif item_id == "CookedMeat":
		box.size = Vector3(0.4, 0.1, 0.4)
		mat.albedo_color = Color(0.4, 0.2, 0.0)
	elif item_id == "Bun":
		box.size = Vector3(0.5, 0.2, 0.5)
		mat.albedo_color = Color(0.9, 0.8, 0.5)
	elif item_id == "Burger":
		box.size = Vector3(0.5, 0.3, 0.5)
		mat.albedo_color = Color(0.6, 0.4, 0.2)
	else:
		box.size = Vector3(0.4, 0.3, 0.4)
		mat.albedo_color = Color(1.0, 1.0, 1.0)
		
	box.material = mat
	mesh.mesh = box
	add_child(mesh)
