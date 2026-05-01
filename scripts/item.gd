extends Node3D
class_name Item



@export var item_name: String = "RawBurger"



func _ready():
	var mesh = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(0.5, 0.1, 0.5) if item_name == "RawBurger" else Vector3(0.4, 0.3, 0.4)
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.8, 0.2, 0.2) if item_name == "RawBurger" else Color(0.4, 0.2, 0.0)
	box.material = mat
	mesh.mesh = box
	add_child(mesh)
