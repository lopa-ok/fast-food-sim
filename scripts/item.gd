extends Node3D
class_name Item

@export var item_id: String = "RawMeat"

func _ready():
	_setup_visual()


func set_item(name_string: String):
	item_id = name_string
	_setup_visual()

func _setup_visual():
	for child in get_children():
		if child is MeshInstance3D or child is Node3D:
			child.visible = false

	var model_name = item_id + "Model"
	if has_node(model_name):
		get_node(model_name).visible = true
	else:
		
		var mesh = MeshInstance3D.new()
		var box = BoxMesh.new()
		var mat = StandardMaterial3D.new()
		
		match item_id:
			"RawMeat":
				box.size = Vector3(0.5, 0.1, 0.5)
				mat.albedo_color = Color(0.8, 0.2, 0.2)
			"CookedMeat":
				box.size = Vector3(0.4, 0.1, 0.4)
				mat.albedo_color = Color(0.4, 0.2, 0.0)
			"Bun":
				box.size = Vector3(0.5, 0.2, 0.5)
				mat.albedo_color = Color(0.9, 0.8, 0.5)
			"Burger":
				box.size = Vector3(0.5, 0.3, 0.5)
				mat.albedo_color = Color(0.6, 0.4, 0.2)
			"Potatoes":
				box.size = Vector3(0.4, 0.3, 0.3)
				mat.albedo_color = Color(0.9, 0.9, 0.8)
			"Fries":
				box.size = Vector3(0.3, 0.4, 0.3)
				mat.albedo_color = Color(0.8, 0.7, 0.2)
			_:
				box.size = Vector3(0.4, 0.3, 0.4)
				mat.albedo_color = Color(1.0, 1.0, 1.0)
			
		box.material = mat
		mesh.mesh = box
		add_child(mesh)
