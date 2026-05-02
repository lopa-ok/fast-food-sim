extends StaticBody3D

var item_scene = preload("res://scenes/Item.tscn")

var items_on_station = []

var visual: MeshInstance3D

func _ready():
	if not has_node("Visual"):
		var v = MeshInstance3D.new()
		v.name = "Visual"
		var m = BoxMesh.new()
		m.size = Vector3(0.5, 0.4, 0.5)
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.1, 0.8, 0.1)
		m.material = mat
		v.mesh = m
		v.position.y = 0.5
		add_child(v)
		v.visible = false
		visual = v
	else:
		visual.visible = false

func interact(player):
	if player.held_item != null:
		if items_on_station.size() < 3:
			var item_id = player.take_item()
			if item_id != "":
				print("Added item to assembly station: ", item_id)
				items_on_station.append(item_id)
				_check_recipes()
		else:
			print("Assembly station is full!")
	else:
		if items_on_station.size() == 1 and (items_on_station[0] == "Burger" or items_on_station[0] == "DoubleBurger"):
			var result_item = items_on_station[0]
			print("Player took the ", result_item, "!")
			player.give_item(item_scene, result_item)
			items_on_station.clear()
		elif items_on_station.size() > 0:
			var item = items_on_station.pop_back()
			print("Player took back item: ", item)
			player.give_item(item_scene, item)
	
	update_visuals()

func _check_recipes():
	if items_on_station.size() > 0:
		var result = RecipeManager.check_recipe(items_on_station)
		if result != "":
			print("Recipe matched! Created: ", result)
			items_on_station.clear()
			items_on_station.append(result)

func update_visuals():
	if items_on_station.size() > 0:
		visual.visible = true
		var mat = visual.get_surface_override_material(0)
		if mat == null:
			mat = StandardMaterial3D.new()
			visual.set_surface_override_material(0, mat)
			
		if items_on_station[0] == "Burger" or items_on_station[0] == "DoubleBurger":
			mat.albedo_color = Color(0.6, 0.4, 0.2)
			visual.scale = Vector3(1, 1, 1)
		elif items_on_station.has("CookedMeat") and items_on_station.has("Bun"):
			mat.albedo_color = Color(0.5, 0.5, 0.5)
		else:
			mat.albedo_color = Color(0.9, 0.9, 0.9)
			visual.scale = Vector3(0.5, 0.5, 0.5)
	else:
		visual.visible = false
