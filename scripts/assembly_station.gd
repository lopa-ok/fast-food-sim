extends StaticBody3D


var item_scene = preload("res://scenes/Item.tscn")

var items_on_station = []
var visual_nodes = []
var container: Node3D

func _ready():
	container = Node3D.new()
	container.position.y = 0.5
	add_child(container)
	
func interact(player):
	if player.held_item != null:
		if items_on_station.size() < 3:
			var item_id = player.take_item()
			if item_id != "":
				print("added item to assembly station: ", item_id)
				items_on_station.append(item_id)
				_check_recipes()
		else:
			print("Assembly station is full")
	else:
		if items_on_station.size() == 1 and (items_on_station[0] == "Burger" or items_on_station[0] == "DoubleBurger" or items_on_station[0] == "BurgerCombo"):
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
			print("recipe matched crated: ", result)
			items_on_station.clear()
			items_on_station.append(result)


func update_visuals():
	for node in visual_nodes:
		node.queue_free()
	visual_nodes.clear()
	
	var y_offset = 0.0
	for item_id in items_on_station:
		var item_inst = item_scene.instantiate() as Item
		item_inst.item_id = item_id
		container.add_child(item_inst)
		item_inst.position = Vector3(0, y_offset, 0)
		visual_nodes.append(item_inst)
		
		if item_id == "Bun": y_offset += 0.2
		elif item_id == "CookedMeat": y_offset += 0.1
		elif item_id == "Burger" or item_id == "BurgerCombo" or item_id == "DoubleBurger": y_offset += 0.3
		else: y_offset += 0.15
