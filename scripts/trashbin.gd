extends StaticBody3D

var visual: MeshInstance3D

func _ready():
	if not has_node("Visual"):
		var v = MeshInstance3D.new()
		v.name = "Visual"
		var m = BoxMesh.new()
		m.size = Vector3(0.8, 1.2, 0.8)
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.2, 0.2, 0.2) # Dark grey for trashbin
		m.material = mat
		v.mesh = m
		# Assuming pivot is at center, adjusting y
		v.position.y = 0.0
		add_child(v)
		visual = v
	else:
		visual = get_node("Visual")

func interact(player):
	if player.held_item != null:
		var item_id = player.take_item()
		if item_id != "":
			print("Trashed item: ", item_id)
	else:
		print("Nothing to trash, hands are empty.")
