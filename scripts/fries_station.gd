extends StaticBody3D

var item_scene = preload("res://scenes/Item.tscn")

var has_potatoes: bool = false
var is_cooked: bool = false
var cook_timer: float = 0.0
var cook_time: float = 3.0

@onready var visual = $Visual

func update_color(color: Color):
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	visual.set_surface_override_material(0, mat)
	visual.visible = true

func _process(delta):
	if has_potatoes and not is_cooked:
		cook_timer += delta
		if cook_timer >= cook_time:
			is_cooked = true
			update_color(Color(0.8, 0.7, 0.2)) # golden fries color

func interact(player):
	if not has_potatoes and player.held_item != null and player.held_item.item_id == "Potatoes":
		has_potatoes = true
		is_cooked = false
		cook_timer = 0.0
		update_color(Color(0.9, 0.9, 0.8)) # raw potato color
		player.take_item() # using the correct player method
	elif has_potatoes and is_cooked and player.held_item == null:
		has_potatoes = false
		visual.visible = false
		player.give_item(item_scene, "Fries")
