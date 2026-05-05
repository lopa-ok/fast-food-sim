extends StaticBody3D

var item_scene = preload("res://scenes/Item.tscn")
var cook_time: float = 3.0


var slots = [
	{"has_meat": false, "is_cooked": false, "timer": 0.0},
	{"has_meat": false, "is_cooked": false, "timer": 0.0},
	{"has_meat": false, "is_cooked": false, "timer": 0.0},
	{"has_meat": false, "is_cooked": false, "timer": 0.0}
]



@onready var visuals = [$Visual1, $Visual2, $Visual3, $Visual4]

func _process(delta):
	for i in range(slots.size()):
		if slots[i].has_meat and not slots[i].is_cooked:
			slots[i].timer += delta
			if slots[i].timer >= cook_time:
				slots[i].is_cooked = true
				_update_slot_color(i, Color(0.4, 0.2, 0.0))

func _update_slot_color(index: int, color: Color):
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	visuals[index].set_surface_override_material(0, mat)

func interact(player):
	var closest_slot = -1
	var min_dist = INF
	
	if player.get("interact_ray"):
		var hit_pos = player.interact_ray.get_collision_point()
		var local_pos = to_local(hit_pos)
		for i in range(visuals.size()):
			var dist = Vector2(local_pos.x, local_pos.z).distance_to(Vector2(visuals[i].position.x, visuals[i].position.z))
			if dist < min_dist:
				min_dist = dist
				closest_slot = i
				
	if closest_slot == -1:
		closest_slot = 0


	if player.held_item != null and player.held_item.item_id == "RawMeat":
		if not slots[closest_slot].has_meat:
			_place_meat(player, closest_slot)
		else:
			var empty_slot = _find_empty_slot()
			if empty_slot != -1:
				_place_meat(player, empty_slot)
			
	elif player.held_item == null:
		if slots[closest_slot].has_meat and slots[closest_slot].is_cooked:
			_take_meat(player, closest_slot)
		elif not slots[closest_slot].has_meat:
			var cooked_slot = _find_cooked_slot()
			if cooked_slot != -1:
				_take_meat(player, cooked_slot)

func _place_meat(player, slot_index: int):
	player.take_item()
	slots[slot_index].has_meat = true
	slots[slot_index].is_cooked = false
	slots[slot_index].timer = 0.0
	visuals[slot_index].visible = true
	_update_slot_color(slot_index, Color(0.8, 0.2, 0.2))

func _take_meat(player, slot_index: int):
	player.give_item(item_scene, "CookedMeat")
	slots[slot_index].has_meat = false
	visuals[slot_index].visible = false


func _find_empty_slot() -> int:
	for i in range(slots.size()):
		if not slots[i].has_meat:
			return i
	return -1

func _find_cooked_slot() -> int:
	for i in range(slots.size()):
		if slots[i].has_meat and slots[i].is_cooked:
			return i
	return -1
